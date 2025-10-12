# T-CLO-901

## IaaS
Avant tout, il est nécessaire d'avoir le Terraform CLI Azure CLI d'installés.

On se place dans le dossier /terraform-iaas, on init terraform : 
- `cd terraform-iaas`
- `terraform init`

Si besoin, pour récupérer l'id du Resource Group et Storage Account existants sur depuis azure, il faut rentrer ces deux commandes : 
- `terraform import azurerm_resource_group.rg-nan_1 /subscriptions/6b9318b1-2215-418a-b0fd-ba0832e9b333/resourceGroups/rg-nan_1`
- `terraform import azurerm_storage_account.storage_account /subscriptions/6b9318b1-2215-418a-b0fd-ba0832e9b333/resourceGroups/rg-nan_1/providers/Microsoft.Storage/storageAccounts/terracloudstate28602`

Puis, on se place dans le dossier , et on fait :
- `terraform apply`