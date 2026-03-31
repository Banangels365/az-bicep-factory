#!/bin/bash
# identity-lz/scripts/create_service_principals_script.sh
# Script to create and manage Service Principals

set -e

# Configuration
ORGANIZATION_NAME="${ORGANIZATION_NAME:-contoso}"
ENVIRONMENT="${ENVIRONMENT:-prod}"
SUBSCRIPTION_ID="${SUBSCRIPTION_ID:-}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if app registration exists
app_exists() {
    local app_name=$1
    az ad app list --display-name "$app_name" --query "[0].appId" -o tsv 2>/dev/null
}

# Function to create or get existing service principal
create_or_get_sp() {
    local sp_name=$1
    local role=$2
    local scope=$3
    local description=$4
    
    log_info "Processing Service Principal: $sp_name"
    
    # Check if SP already exists
    existing_app_id=$(app_exists "$sp_name")
    
    if [ -n "$existing_app_id" ]; then
        log_warn "App registration '$sp_name' already exists (App ID: $existing_app_id)"
        
        # Get the service principal object ID
        SP_OBJECT_ID=$(az ad sp show --id "$existing_app_id" --query id -o tsv 2>/dev/null || echo "")
        
        if [ -z "$SP_OBJECT_ID" ]; then
            log_info "Creating service principal from existing app registration..."
            SP_OBJECT_ID=$(az ad sp create --id "$existing_app_id" --query id -o tsv)
        fi
        
        APP_ID=$existing_app_id
    else
        log_info "Creating new App Registration and Service Principal: $sp_name"
        
        # Create app registration with service principal
        sp_output=$(az ad sp create-for-rbac \
            --name "$sp_name" \
            --role "$role" \
            --scopes "$scope" \
            --query "{appId: appId, objectId: id}" -o json)
        
        APP_ID=$(echo "$sp_output" | jq -r '.appId')
        SP_OBJECT_ID=$(az ad sp show --id "$APP_ID" --query id -o tsv)
        
        log_info "Created Service Principal: $sp_name"
        log_info "  App ID: $APP_ID"
        log_info "  Object ID: $SP_OBJECT_ID"
    fi
    
    # Return both IDs as JSON
    echo "{\"appId\":\"$APP_ID\",\"objectId\":\"$SP_OBJECT_ID\"}"
}

# Function to create federated credential for GitHub Actions
create_federated_credential() {
    local app_id=$1
    local credential_name=$2
    local org_name=$3
    local repo_name=$4
    local entity_type=$5  # environment, branch, tag, pull_request
    local entity_value=$6  # name of environment/branch/tag or empty for PR
    
    log_info "Creating federated credential for GitHub Actions..."
    
    # Build the subject based on entity type
    case $entity_type in
        environment)
            subject="repo:${org_name}/${repo_name}:environment:${entity_value}"
            ;;
        branch)
            subject="repo:${org_name}/${repo_name}:ref:refs/heads/${entity_value}"
            ;;
        tag)
            subject="repo:${org_name}/${repo_name}:ref:refs/tags/${entity_value}"
            ;;
        pull_request)
            subject="repo:${org_name}/${repo_name}:pull_request"
            ;;
        *)
            log_error "Invalid entity type: $entity_type"
            return 1
            ;;
    esac
    
    # Create federated credential
    az ad app federated-credential create \
        --id "$app_id" \
        --parameters "{
            \"name\": \"$credential_name\",
            \"issuer\": \"https://token.actions.githubusercontent.com\",
            \"subject\": \"$subject\",
            \"audiences\": [\"api://AzureADTokenExchange\"]
        }" 2>/dev/null || log_warn "Federated credential may already exist"
}

# ==============================================
# VALIDATE PREREQUISITES
# ==============================================

log_info "========================================"
log_info "Creating Service Principals"
log_info "Organization: $ORGANIZATION_NAME"
log_info "Environment: $ENVIRONMENT"
log_info "========================================"
echo ""

if [ -z "$SUBSCRIPTION_ID" ]; then
    log_info "No subscription ID provided, using default subscription..."
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
fi

log_info "Using Subscription ID: $SUBSCRIPTION_ID"
SUBSCRIPTION_SCOPE="/subscriptions/$SUBSCRIPTION_ID"

# ==============================================
# CREATE SERVICE PRINCIPALS
# ==============================================

log_info ""
log_info "Creating Infrastructure Service Principals..."

# Platform Management SP
SP_PLATFORM=$(create_or_get_sp \
    "sp-${ORGANIZATION_NAME}-platform-${ENVIRONMENT}" \
    "Contributor" \
    "$SUBSCRIPTION_SCOPE" \
    "Service Principal for platform management")
PLATFORM_APP_ID=$(echo "$SP_PLATFORM" | jq -r '.appId')
PLATFORM_OBJECT_ID=$(echo "$SP_PLATFORM" | jq -r '.objectId')

# Network Management SP
SP_NETWORK=$(create_or_get_sp \
    "sp-${ORGANIZATION_NAME}-network-${ENVIRONMENT}" \
    "Network Contributor" \
    "$SUBSCRIPTION_SCOPE" \
    "Service Principal for network management")
NETWORK_APP_ID=$(echo "$SP_NETWORK" | jq -r '.appId')
NETWORK_OBJECT_ID=$(echo "$SP_NETWORK" | jq -r '.objectId')

# Application Deployment SP
SP_APP_DEPLOY=$(create_or_get_sp \
    "sp-${ORGANIZATION_NAME}-app-deploy-${ENVIRONMENT}" \
    "Contributor" \
    "$SUBSCRIPTION_SCOPE" \
    "Service Principal for application deployments")
APP_DEPLOY_APP_ID=$(echo "$SP_APP_DEPLOY" | jq -r '.appId')
APP_DEPLOY_OBJECT_ID=$(echo "$SP_APP_DEPLOY" | jq -r '.objectId')

# Monitoring SP (read-only)
SP_MONITORING=$(create_or_get_sp \
    "sp-${ORGANIZATION_NAME}-monitoring-${ENVIRONMENT}" \
    "Monitoring Reader" \
    "$SUBSCRIPTION_SCOPE" \
    "Service Principal for monitoring and alerting")
MONITORING_APP_ID=$(echo "$SP_MONITORING" | jq -r '.appId')
MONITORING_OBJECT_ID=$(echo "$SP_MONITORING" | jq -r '.objectId')

# Backup SP
SP_BACKUP=$(create_or_get_sp \
    "sp-${ORGANIZATION_NAME}-backup-${ENVIRONMENT}" \
    "Backup Contributor" \
    "$SUBSCRIPTION_SCOPE" \
    "Service Principal for backup operations")
BACKUP_APP_ID=$(echo "$SP_BACKUP" | jq -r '.appId')
BACKUP_OBJECT_ID=$(echo "$SP_BACKUP" | jq -r '.objectId')

# ==============================================
# CREATE FEDERATED CREDENTIALS FOR GITHUB ACTIONS
# ==============================================

if [ "$CREATE_GITHUB_FEDERATED" == "true" ]; then
    log_info ""
    log_info "Creating Federated Credentials for GitHub Actions..."
    
    GITHUB_ORG="${GITHUB_ORG:-myorg}"
    GITHUB_REPO="${GITHUB_REPO:-azure-infra}"
    
    # Platform SP - Production environment
    create_federated_credential \
        "$PLATFORM_APP_ID" \
        "github-prod-environment" \
        "$GITHUB_ORG" \
        "$GITHUB_REPO" \
        "environment" \
        "production"
    
    # App Deploy SP - Main branch
    create_federated_credential \
        "$APP_DEPLOY_APP_ID" \
        "github-main-branch" \
        "$GITHUB_ORG" \
        "$GITHUB_REPO" \
        "branch" \
        "main"
fi

# ==============================================
# EXPORT SERVICE PRINCIPAL IDs
# ==============================================

log_info ""
log_info "========================================"
log_info "Exporting Service Principal IDs..."
log_info "========================================"

mkdir -p ./output

# Export to JSON
cat > ./output/service-principals.json <<EOF
{
  "platform": {
    "appId": "$PLATFORM_APP_ID",
    "objectId": "$PLATFORM_OBJECT_ID"
  },
  "network": {
    "appId": "$NETWORK_APP_ID",
    "objectId": "$NETWORK_OBJECT_ID"
  },
  "appDeploy": {
    "appId": "$APP_DEPLOY_APP_ID",
    "objectId": "$APP_DEPLOY_OBJECT_ID"
  },
  "monitoring": {
    "appId": "$MONITORING_APP_ID",
    "objectId": "$MONITORING_OBJECT_ID"
  },
  "backup": {
    "appId": "$BACKUP_APP_ID",
    "objectId": "$BACKUP_OBJECT_ID"
  }
}
EOF

log_info "Service Principal IDs exported to ./output/service-principals.json"

# Export to Azure DevOps variables
if [ -n "$SYSTEM_TEAMFOUNDATIONCOLLECTIONURI" ]; then
    echo "##vso[task.setvariable variable=platformSpAppId;isOutput=true]$PLATFORM_APP_ID"
    echo "##vso[task.setvariable variable=platformSpObjectId;isOutput=true]$PLATFORM_OBJECT_ID"
    echo "##vso[task.setvariable variable=networkSpAppId;isOutput=true]$NETWORK_APP_ID"
    echo "##vso[task.setvariable variable=appDeploySpAppId;isOutput=true]$APP_DEPLOY_APP_ID"
fi

log_info ""
log_info "========================================"
log_info "✅ All Service Principals created!"
log_info "========================================"
log_info ""
log_info "⚠️  IMPORTANT SECURITY NOTES:"
log_info "1. Credentials for these SPs are NOT displayed here"
log_info "2. To get credentials, use: az ad sp credential reset --id <app-id>"
log_info "3. Store credentials securely in Azure Key Vault"
log_info "4. Use Managed Identities where possible instead of SPs"
log_info "5. Enable MFA for all service principals if possible"

exit 0