# Setting up automated daily emails with an Azure Function

A step-by-step build plan for a timer-triggered Azure Function that queries a Synapse Lake database and emails ~20 recipients daily.

---

## 1. Prerequisites

1. Azure subscription
2. Permissions
   1. Resource group
   2. Function apps
   3. Key Vault
   4. Communication Services
3. Synapse workspace access
   1. Serverless SQL pool endpoint for Lake database
4. Python 3.11 and Azure Functions Core Tools locally installed
5. VS Code with Azure Funcitons extension
6. SendGrid account
7. Azure CLI installed as `az login`

# Setting up automated daily emails with an Azure Function + Azure Communication Services

A step-by-step build plan for a timer-triggered Azure Function that queries a Synapse Lake database and emails ~20 recipients daily, using Azure Communication Services (ACS) Email as the sending backend.

---

## 2. Provision Azure resources

```bash
# Variables
RG=rg-daily-email
LOCATION=eastus2
FUNC_APP=func-daily-email-report
STORAGE=stdailyemailfunc
KEYVAULT=kv-daily-email
ACS_NAME=acs-daily-email
EMAIL_SVC=acs-email-daily

# Resource group
az group create --name $RG --location $LOCATION

# Storage account (required by Azure Functions)
az storage account create --name $STORAGE --location $LOCATION \
  --resource-group $RG --sku Standard_LRS

# Function App (Consumption plan, Python, Linux)
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

Enable a **system-assigned managed identity** on the Function App — this is how it will authenticate to Key Vault, Synapse, and ACS, all without stored credentials.

```bash
az functionapp identity assign --name $FUNC_APP --resource-group $RG
```

---

## 3. Provision and verify an email domain

In the Azure portal, open your Email Communication Service resource:

- **Fastest path**: under **Provision Domain**, add an **Azure-managed domain**. It's pre-verified and ready to send within minutes — good for getting the pipeline working end to end quickly.
- **Production path**: add a **custom domain** instead (e.g. `reports.yourcompany.com`), then add the SPF, DKIM, and DKIM2 TXT/CNAME records it gives you to your DNS provider. Verification can take a few minutes to a few hours. Custom domains send with better deliverability and a recognizable "from" address, so plan to move to this before go-live even if you start with the managed domain.

Once the domain shows **Verified**, link it to your ACS resource: open the ACS resource → **Email → Domains → Connect domain** → select the verified domain. Note the **MailFrom address** shown there — you'll use it as the sender.

---

## 4. Grant the Function's managed identity access to ACS

Assign the Function App's managed identity the **Contributor** role (or a narrower custom role scoped to just email-sending, if you want tighter control) on the ACS resource, so it can authenticate via Entra ID rather than a connection string.

```bash
PRINCIPAL_ID=$(az functionapp identity show --name $FUNC_APP --resource-group $RG --query principalId -o tsv)
ACS_ID=$(az communication show --name $ACS_NAME --resource-group $RG --query id -o tsv)

az role assignment create --assignee $PRINCIPAL_ID \
  --role "Contributor" --scope $ACS_ID
```

This means **no ACS connection string or API key needs to be stored anywhere** — a meaningful maintenance win over SendGrid, where an API key has to be generated, stored in Key Vault, and eventually rotated.

---

## 5. Store remaining secrets in Key Vault

Only the Synapse connection string needs to live here now — the email side needs no secret at all.

```bash
az keyvault secret set --vault-name $KEYVAULT --name "SynapseSqlConnStr" --value "<connection-string>"

az keyvault set-policy --name $KEYVAULT \
  --object-id $PRINCIPAL_ID \
  --secret-permissions get list
```

---

## 6. Grant the Function access to Synapse

- In the Synapse workspace, add the Function App's managed identity as a database user on the Lake database (or the serverless SQL pool) with `SELECT` permission on the relevant view/table only.
- If Synapse firewall rules restrict access by IP, add "Allow Azure services and resources to access this workspace," or if using VNet integration, configure the Function App's outbound VNet integration to reach Synapse privately.
- Test this connection early — it's the step most likely to surprise you (auth type, firewall, driver version mismatches).

---

## 7. Scaffold the function locally

```bash
func init DailyEmailFunction --python
cd DailyEmailFunction
func new --name SendDailyEmail --template "Timer trigger"
```

Set the schedule in `function.json` (CRON format, e.g. 6:00 AM UTC daily):

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

Add to `requirements.txt`:

```
azure-identity
azure-keyvault-secrets
azure-communication-email
pyodbc
jinja2
```

You'll also need the ODBC driver for SQL Server available in the Function's runtime for the Synapse query — for Linux/containerized Functions this typically means a custom container or a base image that includes `msodbcsql18`. Confirm this before writing code.

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

ACS_ENDPOINT = os.environ["ACS_ENDPOINT"]  # e.g. https://acs-daily-email.communication.azure.com
SENDER_ADDRESS = os.environ["SENDER_ADDRESS"]  # the MailFrom address from step 3

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
    poller.result()  # waits for send confirmation
```

Note the auth pattern: `DefaultAzureCredential()` is passed straight into `EmailClient` — the same managed identity handles Key Vault access and email sending, no separate credential type to manage.

---

## 10. Build the email template

Create `email_template.html` with Jinja2 placeholders (`{{ name }}`, `{{ metric }}`, etc.). Use inline styles and a simple table layout — email clients render modern CSS poorly.

---

## 11. Test locally

```bash
func start
```

- Trigger the timer function manually via the Functions Core Tools admin API, or temporarily wrap the logic in an HTTP trigger for easier manual testing.
- Point at a **test/staging view** or add a dry-run flag that logs the rendered email instead of calling `begin_send`, so you're not spamming real recipients during development.
- For local Key Vault + ACS access, run `az login` locally so `DefaultAzureCredential` picks up your own identity (make sure your account also has the Key Vault policy and ACS role assignment, or temporarily grant them for testing).

---

## 12. Deploy

```bash
func azure functionapp publish $FUNC_APP
```

Set required app settings:

```bash
az functionapp config appsettings set --name $FUNC_APP --resource-group $RG \
  --settings \
  "KEYVAULT_URL=https://$KEYVAULT.vault.azure.net/" \
  "ACS_ENDPOINT=https://$ACS_NAME.communication.azure.com" \
  "SENDER_ADDRESS=DoNotReply@<your-verified-domain>"
```

Wire this into CI/CD (GitHub Actions or Azure DevOps) so deployments are automatic on merge to main, rather than manual `func publish` runs, once this moves beyond initial testing.

---

## 13. Set up monitoring and alerting

- Enable **Application Insights** on the Function App (usually on by default) for execution history, failures, and duration per run.
- Create an **Azure Monitor alert rule** on Function failures so you're notified if a run errors out.
- Use ACS's **Get email message status** capability (via `poller.result()` in the code above, or the `azure-communication-email` status APIs) to confirm delivery rather than just assuming a successful API call means a delivered email.
- Log a clear success/failure line each run (sent count, failed count, which recipients failed).

---

## 14. Production hardening checklist

- [ ] Per-recipient try/except already included above, so one bad address doesn't stop the batch — confirm failures are logged with enough detail to act on
- [ ] Move to a **custom verified domain** if you started with the Azure-managed domain, for better deliverability and a proper "from" address
- [ ] Timezone-aware CRON schedule (Function CRON is UTC by default — confirm what "6 AM" means for your recipients)
- [ ] Narrow the managed identity's ACS role from Contributor to a scoped custom role if your security posture requires least-privilege (Contributor is broader than strictly needed for just sending email)
- [ ] Staging slot or a separate test Function App for changes before they hit production
- [ ] Basic unit tests for `query_lake_database`, `render_email`, and `send_email` (mock the external calls)

---

## Rough time estimate

**0.5 day** for steps 1–11 (working end to end locally against real data) — slightly faster than the SendGrid version, since there's no external account signup, no API key to generate/store, and auth is handled entirely through the managed identity already in place. Add another **half day** for deployment, monitoring, and hardening (steps 12–14).