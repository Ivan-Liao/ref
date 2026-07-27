- [General Info](#general-info)
- [Security](#security)

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