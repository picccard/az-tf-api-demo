# az-tf-api-demo

create new subsciption in azure
create repo
create an service principal to run Terraform in GitHub Actions and grant it Contributor access to the Azure subscription.

```bash
az ad sp create-for-rbac --name "sp-myproject-demo" --role Contributor --scopes /subscriptions/6xxxxxx-xxxx-xxxx-xxxx-xxxxxxxx --sdk-auth
```

```json
{
  "clientId": "4xxxxx-xxxx-xxxx-xxxx-xxxxxxx",
  "clientSecret": "uxyxyxyxyxyyxyxyx",
  "subscriptionId": "6xxxxxxx-xxxx-xxxx-xxxx-xxxxxxx",
  "tenantId": "6xxxxxxx-xxxx-xxxx-xxxx-xxxxxx",
}
```

create storage account for tf statefile
```bash
az group create -g rg-euw-az-tf-api-demo -l westeurope
az storage account create -n aztfapidemoeula -g rg-euw-az-tf-api-demo -l westeurope --sku Standard_LRS
az storage container create -n terraform-state --account-name aztfapidemoeula
```

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-euw-az-tf-api-demo"
    storage_account_name = "aztfapidemoeula"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
```

# Scripted

```bash
#!/bin/bash

RESOURCE_GROUP_NAME=rg-terraform-tfstate
STORAGE_ACCOUNT_NAME=devtfstate$RANDOM
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```