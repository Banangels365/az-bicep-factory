SP_ID=$(az ad sp list --display-name "sp-github-bicep-rootmg" --query "[0].id" -o tsv)
ROOT_MG_ID=$(az account show --query tenantId -o tsv)

# Pour déployer l'infrastructure
az role assignment create \
  --assignee $SP_ID \
  --role "Owner" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"

# Pour gérer les Management Groups
az role assignment create \
  --assignee $SP_ID \
  --role "Management Group Contributor" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"

# Pour gérer les Policies
az role assignment create \
  --assignee $SP_ID \
  --role "Resource Policy Contributor" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"

# Pour gérer les Blueprints (si utilisés)
az role assignment create \
  --assignee $SP_ID \
  --role "Blueprint Contributor" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"