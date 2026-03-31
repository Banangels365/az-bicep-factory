#!/bin/bash
# Scripts/deploy-sp-landing-zone.sh
# Create Service Principal for GitHub Actions using OIDC
# Assign RBAC at Management Group Root level

set -euo pipefail

GITHUB_USERNAME="Banangels365"
REPO_NAME="az-bicep-factory"
SP_NAME="sp-mg-az-demo-lz"

echo "Getting Tenant ID..."
TENANT_ID=$(az account show --query tenantId -o tsv)

echo "Getting Root Management Group ID..."
ROOT_MG_ID=$(az account management-group list \
  --query "[?displayName=='Tenant Root Group'].name" \
  -o tsv)

if [ -z "$ROOT_MG_ID" ]; then
  echo "Could not determine Root Management Group ID."
  exit 1
fi

echo "Creating Azure AD Application..."
APP_ID=$(az ad app create \
  --display-name "$SP_NAME" \
  --query appId -o tsv)

echo "Creating Service Principal..."
az ad sp create --id "$APP_ID" > /dev/null

echo "Assigning RBAC role at Root Management Group..."
az role assignment create \
  --assignee "$APP_ID" \
  --role Owner \
  --scope /providers/Microsoft.Management/managementGroups/$ROOT_MG_ID

az role assignment create \
  --assignee "$APP_ID" \
  --role Contributor \
  --scope /providers/Microsoft.Management/managementGroups/$ROOT_MG_ID

echo "Adding Federated Credential (OIDC)..."
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters "{
    \"name\": \"github-oidc-environment\",
    \"issuer\": \"https://token.actions.githubusercontent.com\",
    \"subject\": \"repo:${GITHUB_USERNAME}/${REPO_NAME}:environment:Sandbox\",
    \"description\": \"GitHub Actions OIDC via Environment\",
    \"audiences\": [\"api://AzureADTokenExchange\"]
  }"

echo ""
echo "==========================================="
echo "Service Principal successfully created!"
echo "==========================================="
echo "CLIENT_ID: $APP_ID"
echo "TENANT_ID: $TENANT_ID"
echo "ROOT_MANAGEMENT_GROUP: $ROOT_MG_ID"
echo ""
echo "Add these values as GitHub repository secrets:"
echo "- AZURE_CLIENT_ID"
echo "- AZURE_TENANT_ID"
echo "- AZURE_SUBSCRIPTION_ID (optional if needed)"

# If the script fail to execute due to Microsoft graph conections, 
# Run this command in Azure Cloud Shell (Bash) to refresh permissions for the app. 
# This is needed if you get errors related to Microsoft Graph permissions when running the script.:
# az login --scope "https://graph.microsoft.com/.default"