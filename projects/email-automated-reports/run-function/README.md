# Setting up automated daily emails with an Azure Function + Azure Communication Services

Revised for an environment with an existing resource group, existing storage account, and an existing organizational domain on Microsoft 365.

---

## 0. Assumptions and one decision to make upfront

- **Resource group** and **storage account** already exist — steps below reuse them rather than creating new ones.
- **Domain**: your organization's domain is already active on Microsoft 365 (Exchange Online), which means it already has SPF/DKIM records supporting that mail flow. **Don't point ACS at the root domain directly** — modifying the existing SPF record risks breaking normal company email (SPF allows only one record per domain, and has a 10-DNS-lookup limit that's easy to blow past by merging services carelessly).
- **Recommended fix**: use a **subdomain** dedicated to this workload, e.g. `reports.yourcompany.com` or `notifications.yourcompany.com`. This gets its own independent SPF/DKIM records, sends from an address like `daily-report@reports.yourcompany.com`, and cannot interfere with the org's primary mail flow. This is Microsoft's own recommended pattern for adding ACS Email alongside an existing mail system.
- This means you'll need **5–10 minutes of a DNS admin's time** (whoever manages your company's DNS zone) to add a handful of TXT/CNAME records for the subdomain. Loop them in early since this is the one step outside your own control.

---

## 1. Reuse existing resources

```bash
# Reference existing resources — replace with your actual names
RG=<your-existing-resource-group>
STORAGE=<your-existing-storage-account>
LOCATION=<region your resource group is in>

FUNC_APP=func-daily-email-report
KEYVAULT=kv-daily-email
ACS_NAME=acs-daily-email
EMAIL_SVC=acs-email-daily

# Confirm they exist (sanity check before proceeding)
az group show --name $RG
az storage account show --name $STORAGE --resource-group $RG
```

No creation commands needed for these two — just make sure the storage account is in a region compatible with where you'll deploy the Function App (same region avoids cross-region latency/egress and keeps things simple).

---

## 2. Create the Function App, Key Vault, and ACS resources

These are still new — only the RG and storage account are being reused.

```bash
# Function App (Consumption plan, Python, Linux) — points at the existing storage account
az functionapp create --resource-group $RG --consumption-plan-location $LOCATION \
  --runtime python --runtime-version 3.11 --functions-version 4 \
  --name $FUNC_APP --storage-account $STORAGE --os-type Linux

# Key Vault
az keyvault create --name $KEYVAULT --resource-group $RG --location $LOCATION

# Email Communication Service (the domain-hosting piece)
az communication email create --name $EMAIL_SVC --resource-group $RG \
  --location "Global" --data-location "United States"

# Azure Communication Services resource (the sending piece)
az communication create --name $ACS_NAME --resource-group $RG \
  --location "Global" --data-location "United States"
```

Enable a **system-assigned managed identity** on the Function App — this authenticates to Key Vault, Synapse, and ACS, with no stored credentials.

```bash
az functionapp identity assign --name $FUNC_APP --resource-group $RG
```

> **Note on the existing storage account**: if it's shared with other workloads, Azure Functions will create its own containers/queues/tables inside it for its internal bookkeeping (locks, triggers state). This is normal and won't interfere with other data already there, but worth flagging to whoever owns that storage account so it isn't a surprise.

---

## 3. Set up the subdomain for ACS

1. In the Azure portal, open the **Email Communication Service** resource → **Provision Domain** → **Add custom domain**.
2. Enter the subdomain, e.g. `reports.yourcompany.com` (not the root domain).
3. Azure gives you a set of DNS records to add: SPF (TXT), DKIM (CNAME x2), and DKIM2 (CNAME x2), plus optionally a DMARC record.
4. Send these to your DNS admin (or add them yourself if you manage the zone) — they only touch the new subdomain, so there's no risk to existing M365 mail flow on the root domain.
5. Wait for verification (usually a few minutes to a few hours depending on DNS propagation and how the records were added).
6. Once verified, link the domain to your ACS resource: ACS resource → **Email → Domains → Connect domain**. Note the **MailFrom address**, e.g. `DoNotReply@reports.yourcompany.com`.

---

## 4. Grant the Function's managed identity access to ACS

```bash
PRINCIPAL_ID=$(az functionapp identity show --name $FUNC_APP --resource-group $RG --query principalId -o tsv)
ACS_ID=$(az communication show --name $ACS_NAME --resource-group $RG --query id -o tsv)

az role assignment create --assignee $PRINCIPAL_ID \
  --role "Contributor" --scope $ACS_ID
```

No connection string or API key to generate or store — auth happens entirely through the managed identity.

---

## 5. Store the Synapse connection string in Key Vault

```bash
az keyvault secret set --vault-name $KEYVAULT --name "SynapseSqlConnStr" --value "<connection-string>"

az keyvault set-policy --name $KEYVAULT \
  --object-id $PRINCIPAL_ID \
  --secret-permissions get list
```

---

## 6. Grant the Function access to Synapse

- Add the Function App's managed identity as a database user on the Lake database (or serverless SQL pool) with `SELECT` permission on the relevant view/table only.
- Adjust Synapse firewall rules ("Allow Azure services and resources to access this workspace") or VNet integration as needed.
- Test this connection early — it's the step most likely to surprise you.

---

## 7. Scaffold the function locally

```bash
func init DailyEmailFunction --python
cd DailyEmailFunction
func new --name SendDailyEmail --template "Timer trigger"
```

`function.json` schedule (CRON, e.g. 6:00 AM UTC daily):

```json
{
  "bindings": [
    {
      "name": "mytimer",
      "type": "timerTrigger",
      "direction": "in",
      "schedule": "0 0 6 * * *"
    }
  ]
}
```

---

## 8. Install dependencies

`requirements.txt`:

```
azure-identity
azure-keyvault-secrets
azure-communication-email
pyodbc
jinja2
```

Confirm the ODBC driver (`msodbcsql18`) is available in your Function's runtime for the Synapse query — needs a custom container or compatible base image on Linux Functions.

---

## 9. Write the function logic

```python
import os
import logging
import pyodbc
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from azure.communication.email import EmailClient
from jinja2 import Template

ACS_ENDPOINT = os.environ["ACS_ENDPOINT"]
SENDER_ADDRESS = os.environ["SENDER_ADDRESS"]  # e.g. DoNotReply@reports.yourcompany.com

def main(mytimer) -> None:
    credential = DefaultAzureCredential()
    kv_client = SecretClient(vault_url=os.environ["KEYVAULT_URL"], credential=credential)

    conn_str = kv_client.get_secret("SynapseSqlConnStr").value
    rows = query_lake_database(conn_str)

    if not rows:
        logging.info("No rows returned — skipping send.")
        return

    email_client = EmailClient(ACS_ENDPOINT, credential)

    sent, failed = 0, 0
    for recipient in rows:
        try:
            send_email(email_client, recipient)
            sent += 1
        except Exception as ex:
            logging.error(f"Failed to send to {recipient.get('email')}: {ex}")
            failed += 1

    logging.info(f"Sent {sent} emails, {failed} failed.")


def query_lake_database(conn_str):
    with pyodbc.connect(conn_str) as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM dbo.daily_report_view")
        columns = [col[0] for col in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]


def render_email(data):
    template = Template(open("email_template.html").read())
    return template.render(**data)


def send_email(email_client, recipient):
    message = {
        "senderAddress": SENDER_ADDRESS,
        "recipients": {"to": [{"address": recipient["email"]}]},
        "content": {
            "subject": "Your daily report",
            "html": render_email(recipient),
        },
    }
    poller = email_client.begin_send(message)
    poller.result()
```

---

## 10. Build the email template

Create `email_template.html` with Jinja2 placeholders. Use inline styles and a simple table — email clients render modern CSS poorly.

---

## 11. Test locally

```bash
func start
```

- Trigger the timer manually via the Functions Core Tools admin API, or temporarily wrap the logic in an HTTP trigger for easier testing.
- Point at a test/staging view, or add a dry-run flag that logs the rendered email instead of calling `begin_send`.
- Run `az login` locally so `DefaultAzureCredential` picks up your identity — make sure your account also has the Key Vault policy and ACS role assignment for testing, or grant them temporarily.

---

## 12. Deploy

```bash
func azure functionapp publish $FUNC_APP
```

```bash
az functionapp config appsettings set --name $FUNC_APP --resource-group $RG \
  --settings \
  "KEYVAULT_URL=https://$KEYVAULT.vault.azure.net/" \
  "ACS_ENDPOINT=https://$ACS_NAME.communication.azure.com" \
  "SENDER_ADDRESS=DoNotReply@reports.yourcompany.com"
```

Wire into CI/CD (GitHub Actions or Azure DevOps) once past initial testing.

---

## 13. Monitoring and alerting

- Enable **Application Insights** on the Function App.
- Create an **Azure Monitor alert rule** on Function failures.
- Use the `poller.result()` call to confirm delivery status rather than assuming success from the API call alone.
- Log sent/failed counts each run.

---

## 14. Production hardening checklist

- [ ] Per-recipient try/except already included — confirm failures log enough detail to act on
- [ ] Narrow the managed identity's ACS role from Contributor to a scoped custom role if least-privilege is required
- [ ] Timezone-aware CRON schedule (Function CRON is UTC by default)
- [ ] Staging slot or separate test Function App before production changes
- [ ] Basic unit tests for `query_lake_database`, `render_email`, and `send_email`
- [ ] Confirm with your DNS/M365 admin that the subdomain's DMARC policy (if any) is set appropriately — some orgs enforce a strict DMARC policy that can affect subdomain mail differently than the root domain

---

## Rough time estimate

**0.5 day** of your own hands-on-keyboard time for steps 1–11, similar to before — reusing the resource group and storage account saves a small amount of setup but doesn't change the core build time. The real variable is **DNS turnaround** for step 3: if your DNS admin can add records same-day, you're done in half a day total; if it goes through a change-request process, budget an extra day or two of calendar time (not effort) waiting on that approval, separate from the ~half day of hardening/deployment work in steps 12–14.