#!/bin/bash
# deploy-sp-landing-zone.sh

set -e  # Arrêter en cas d'erreur

echo "=== Création du Service Principal pour Azure Landing Zone ==="

# Variables
SP_NAME="sp-github-bicep-rootmg"
ROOT_MG_ID=$(az account show --query tenantId -o tsv)

# 1. Créer le SP avec le rôle de base
echo "Création du Service Principal..."
SP_OUTPUT=$(az ad sp create-for-rbac \
  --name "$SP_NAME" \
  --role "Contributor" \
  --scopes "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID" \
  --sdk-auth)

echo "$SP_OUTPUT"
echo ""
echo "⚠️  IMPORTANT: Sauvegardez ce JSON dans GitHub Secrets (AZURE_CREDENTIALS)"
echo ""

# Récupérer l'ID du SP (nécessaire pour les assignments suivants)
SP_ID=$(az ad sp list --display-name "$SP_NAME" --query "[0].id" -o tsv)
echo "Service Principal ID: $SP_ID"

# Attendre quelques secondes pour la propagation AD
echo "Attente de la propagation Azure AD..."
sleep 10

# 2. Assigner les rôles additionnels
echo ""
echo "=== Assignment des rôles additionnels ==="

# Owner (pour gérer les RBAC et déployer toutes ressources)
echo "Assignment du rôle 'Owner'..."
az role assignment create \
  --assignee "$SP_ID" \
  --role "Owner" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"

# Management Group Contributor
echo "Assignment du rôle 'Management Group Contributor'..."
az role assignment create \
  --assignee "$SP_ID" \
  --role "Management Group Contributor" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"

# Resource Policy Contributor
echo "Assignment du rôle 'Resource Policy Contributor'..."
az role assignment create \
  --assignee "$SP_ID" \
  --role "Resource Policy Contributor" \
  --scope "/providers/Microsoft.Management/managementGroups/$ROOT_MG_ID"

# 3. Vérification
echo ""
echo "=== Vérification des rôles assignés ==="
az role assignment list \
  --assignee "$SP_ID" \
  --all \
  --output table

echo ""
echo "✅ Service Principal créé et configuré avec succès!"