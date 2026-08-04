- [General Info](#general-info)
- [Security](#security)
- [Storage account](#storage-account)
- [Subscriptions](#subscriptions)

# General Info
1. Subscription list ... `az account list`
   1. Set supscription ... `az account set --subscription 'SUBSCRIPTION_NAME_HERE'`
2. Command list ... `az`
   1. Command list subcommand help ... `az synapse --help`

# Security
1. Create user
```
az ad user create --display-name "Ivy Liao" \
                  --password "PASSWORD_HERE" \
                  --user-principal-name "ivy.liao@ivanhliaooutlook.onmicrosoft.com" \
                  --force-change-password-next-sign-in true \
                  --mail-nickname "IvyL"
```

# Storage account
1. Create new container
```
az storage account list --output table

az storage container create \
    --name <your-container-name> \
    --account-name <your-storage-account-name> \
    --auth-mode login


```

# Subscriptions
1. List and change subscriptions
   ```
   az account list --output table
   az account set --subscription <subscription-name-or-id>
   ```
2. test