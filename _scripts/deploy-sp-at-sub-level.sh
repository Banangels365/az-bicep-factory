#!/bin/bash
# Scripts/deploy-sp-landing-zone.sh
# Create Service Principal for GitHub Actions using OIDC

set -euo pipefail

SUBSCRIPTION_ID="0061dc3e-7704-4778-bcda-b566d000d486"
GITHUB_USERNAME="Banangels365"
REPO_NAME="az-bicep-factory"
SP_NAME="sp-sub-az-demo-lz"

echo "Creating Azure AD Application..."

APP_ID=$(az ad app create \
  --display-name "$SP_NAME" \
  --query appId -o tsv)

echo "Creating Service Principal..."

az ad sp create --id "$APP_ID" > /dev/null

echo "Assigning RBAC role..."

az role assignment create \
  --assignee "$APP_ID" \
  --role "Owner" \
  --scope /subscriptions/$SUBSCRIPTION_ID

az role assignment create \
  --assignee "$APP_ID" \
  --role "User Access Administrator" \
  --scope /subscriptions/$SUBSCRIPTION_ID


echo "Adding Federated Credential (OIDC)..."

az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters "{
    \"name\": \"github-oidc\",
    \"issuer\": \"https://token.actions.githubusercontent.com\",
    \"subject\": \"repo:${GITHUB_USERNAME}/${REPO_NAME}:environment:Sandbox\", 
    \"description\": \"GitHub Actions OIDC\",
    \"audiences\": [\"api://AzureADTokenExchange\"]
  }"

echo ""
echo "==========================================="
echo "Service Principal successfully created!"
echo "==========================================="
echo "CLIENT_ID: $APP_ID"
echo "TENANT_ID: $(az account show --query tenantId -o tsv)"
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo ""
echo "Add these values as GitHub repository secrets:"
echo "- AZURE_CLIENT_ID"
echo "- AZURE_TENANT_ID"
echo "- AZURE_SUBSCRIPTION_ID"
