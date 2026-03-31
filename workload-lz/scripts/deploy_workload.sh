#!/bin/bash
# scripts/deploy-workload.sh
# Script to deploy a complete Workload Landing Zone

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Parameters
ORGANIZATION_NAME="${ORGANIZATION_NAME:-contoso}"
WORKLOAD_NAME="${WORKLOAD_NAME:-crm}"
ENVIRONMENT="${ENVIRONMENT:-prod}"
LOCATION="${LOCATION:-canadacentral}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Function to check prerequisites
check_prerequisites() {
    log_section "Checking Prerequisites"
    
    # Check Azure CLI
    if ! command -v az &> /dev/null; then
        log_error "Azure CLI not found"
        exit 1
    fi
    log_info "✓ Azure CLI: $(az version --query '\"azure-cli\"' -o tsv)"
    
    # Check Bicep
    if ! command -v bicep &> /dev/null; then
        log_warn "Bicep CLI not found. Installing..."
        az bicep install
    fi
    log_info "✓ Bicep CLI: $(bicep --version)"
    
    # Check if logged in
    if ! az account show &> /dev/null; then
        log_error "Not logged in to Azure. Please run 'az login'"
        exit 1
    fi
    
    CURRENT_USER=$(az account show --query user.name -o tsv)
    CURRENT_SUBSCRIPTION=$(az account show --query name -o tsv)
    CURRENT_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    
    log_info "✓ Logged in as: $CURRENT_USER"
    log_info "✓ Subscription: $CURRENT_SUBSCRIPTION"
    log_info "✓ Subscription ID: $CURRENT_SUBSCRIPTION_ID"
}

# Function to validate required resources
validate_dependencies() {
    log_section "Validating Dependencies"
    
    log_info "Checking if Hub VNet exists..."
    
    # Try to find Hub VNet
    HUB_VNET=$(az network vnet list --query "[?contains(name, 'hub')].{id:id, name:name, rg:resourceGroup}" -o json)
    
    if [ "$(echo $HUB_VNET | jq '. | length')" -eq 0 ]; then
        log_error "Hub VNet not found. Please deploy Connectivity Landing Zone first."
        exit 1
    fi
    
    HUB_VNET_ID=$(echo $HUB_VNET | jq -r '.[0].id')
    HUB_VNET_NAME=$(echo $HUB_VNET | jq -r '.[0].name')
    HUB_VNET_RG=$(echo $HUB_VNET | jq -r '.[0].rg')
    
    log_info "✓ Found Hub VNet: $HUB_VNET_NAME"
    log_info "  ID: $HUB_VNET_ID"
    log_info "  Resource Group: $HUB_VNET_RG"
    
    # Check for Azure Firewall
    log_info "Checking for Azure Firewall..."
    FIREWALL=$(az network firewall list --query "[?contains(name, '${ORGANIZATION_NAME}')].{name:name, ip:ipConfigurations[0].properties.privateIPAddress}" -o json)
    
    if [ "$(echo $FIREWALL | jq '. | length')" -eq 0 ]; then
        log_warn "Azure Firewall not found. Network routing may not work correctly."
        FIREWALL_IP="10.0.1.4"  # Default
    else
        FIREWALL_IP=$(echo $FIREWALL | jq -r '.[0].ip')
        log_info "✓ Found Firewall with IP: $FIREWALL_IP"
    fi
    
    # Check for Log Analytics
    log_info "Checking for Log Analytics Workspace..."
    LAW=$(az monitor log-analytics workspace list --query "[?contains(name, 'platform')].id" -o tsv | head -n 1)
    
    if [ -z "$LAW" ]; then
        log_error "Log Analytics Workspace not found. Please deploy Platform Landing Zone first."
        exit 1
    fi
    
    log_info "✓ Found Log Analytics: $LAW"
    
    # Check for Managed Identity
    log_info "Checking for Managed Identity..."
    MI=$(az identity list --query "[?contains(name, 'app-deploy')].id" -o tsv | head -n 1)
    
    if [ -z "$MI" ]; then
        log_warn "Managed Identity not found. Will use System-Assigned identity."
        MI=""
    else
        log_info "✓ Found Managed Identity: $MI"
    fi
}

# Function to create Private DNS Zones if not exist
create_private_dns_zones() {
    log_section "Creating Private DNS Zones"
    
    ZONES=(
        "privatelink.azurewebsites.net"
        "privatelink.database.windows.net"
        "privatelink.blob.core.windows.net"
        "privatelink.vaultcore.azure.net"
    )
    
    for ZONE in "${ZONES[@]}"; do
        log_info "Checking Private DNS Zone: $ZONE"
        
        ZONE_EXISTS=$(az network private-dns zone show \
            --resource-group "$HUB_VNET_RG" \
            --name "$ZONE" \
            --query id -o tsv 2>/dev/null || echo "")
        
        if [ -z "$ZONE_EXISTS" ]; then
            log_info "Creating Private DNS Zone: $ZONE"
            
            az network private-dns zone create \
                --resource-group "$HUB_VNET_RG" \
                --name "$ZONE"
            
            # Link to Hub VNet
            az network private-dns link vnet create \
                --resource-group "$HUB_VNET_RG" \
                --zone-name "$ZONE" \
                --name "link-to-hub" \
                --virtual-network "$HUB_VNET_ID" \
                --registration-enabled false
            
            log_info "✓ Created and linked zone: $ZONE"
        else
            log_info "✓ Zone already exists: $ZONE"
        fi
    done
}

# Function to generate parameters file
generate_parameters() {
    log_section "Generating Parameters File"
    
    # Get Private DNS Zone IDs
    PDNS_SITES=$(az network private-dns zone show -g "$HUB_VNET_RG" -n privatelink.azurewebsites.net --query id -o tsv)
    PDNS_SQL=$(az network private-dns zone show -g "$HUB_VNET_RG" -n privatelink.database.windows.net --query id -o tsv)
    PDNS_BLOB=$(az network private-dns zone show -g "$HUB_VNET_RG" -n privatelink.blob.core.windows.net --query id -o tsv)
    PDNS_KV=$(az network private-dns zone show -g "$HUB_VNET_RG" -n privatelink.vaultcore.azure.net --query id -o tsv)
    
    # Generate random password
    SQL_PASSWORD="P@ssw0rd-$(openssl rand -base64 12)"
    
    log_warn "SQL Admin Password (SAVE THIS): $SQL_PASSWORD"
    
    # Create parameters file
    PARAMS_FILE="$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/main.bicepparam"
    mkdir -p "$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}"
    
    cat > "$PARAMS_FILE" <<EOF
// workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/main.bicepparam
// Auto-generated by deploy-workload.sh
using '../app-example/main.bicep'

param organizationName = '$ORGANIZATION_NAME'
param workloadName = '$WORKLOAD_NAME'
param environment = '$ENVIRONMENT'
param location = '$LOCATION'

// Networking
param spokeVnetAddressPrefix = '10.3.0.0/20'
param webSubnetAddressPrefix = '10.3.0.0/24'
param appSubnetAddressPrefix = '10.3.1.0/24'
param dataSubnetAddressPrefix = '10.3.2.0/24'
param privateEndpointsSubnetAddressPrefix = '10.3.4.0/24'

// Hub configuration
param hubVnetId = '$HUB_VNET_ID'
param hubVnetResourceGroupName = '$HUB_VNET_RG'
param hubVnetSubscriptionId = '$CURRENT_SUBSCRIPTION_ID'
param azureFirewallPrivateIp = '$FIREWALL_IP'

// Application configuration
param appServicePlanSku = 'P1v3'
param appServiceRuntimeStack = 'dotnetcore'
param appServiceRuntimeVersion = '8'

// Database configuration
param sqlDatabaseSku = 'GP_Gen5_2'
param sqlAdminLogin = 'sqladmin'
param sqlAdminPassword = '$SQL_PASSWORD'
param sqlAzureADAdminObjectId = '00000000-0000-0000-0000-000000000000'
param sqlAzureADAdminLogin = 'DB-Admins'

// Identity
param managedIdentityId = '${MI:-}'

// Shared resources
param logAnalyticsWorkspaceId = '$LAW'
param privateDnsZoneIdSites = '$PDNS_SITES'
param privateDnsZoneIdSql = '$PDNS_SQL'
param privateDnsZoneIdBlob = '$PDNS_BLOB'
param privateDnsZoneIdKeyVault = '$PDNS_KV'

param enableDdosProtection = false
param ddosProtectionPlanId = ''

param tags = {
  Environment: '$ENVIRONMENT'
  ManagedBy: 'Bicep'
  Workload: '$WORKLOAD_NAME'
  DeployedBy: '$CURRENT_USER'
  DeployedAt: '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
}
EOF
    
    log_info "✓ Parameters file created: $PARAMS_FILE"
    
    # Save password to file
    echo "$SQL_PASSWORD" > "$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/.sql-password"
    chmod 600 "$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/.sql-password"
    log_warn "Password saved to: workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/.sql-password"
}

# Function to validate deployment
validate_deployment() {
    log_section "Validating Deployment"
    
    cd "$PROJECT_ROOT/workloads/app-example"
    
    log_info "Running Bicep validation..."
    
    az deployment sub validate \
        --location "$LOCATION" \
        --template-file main.bicep \
        --parameters "$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/main.bicepparam"
    
    if [ $? -ne 0 ]; then
        log_error "Validation failed"
        exit 1
    fi
    
    log_info "✓ Validation successful"
}

# Function to deploy workload
deploy_workload() {
    log_section "Deploying Workload"
    
    cd "$PROJECT_ROOT/workloads/app-example"
    
    DEPLOYMENT_NAME="${WORKLOAD_NAME}-${ENVIRONMENT}-deployment-$(date +%Y%m%d-%H%M%S)"
    
    log_info "Deployment name: $DEPLOYMENT_NAME"
    log_info "Starting deployment (this may take 15-20 minutes)..."
    
    az deployment sub create \
        --name "$DEPLOYMENT_NAME" \
        --location "$LOCATION" \
        --template-file main.bicep \
        --parameters "$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/main.bicepparam"
    
    if [ $? -ne 0 ]; then
        log_error "Deployment failed"
        exit 1
    fi
    
    log_info "✓ Deployment completed successfully"
    
    # Save outputs
    log_info "Saving deployment outputs..."
    az deployment sub show \
        --name "$DEPLOYMENT_NAME" \
        --query properties.outputs \
        -o json > "$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/deployment-outputs.json"
    
    log_info "✓ Outputs saved to: workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/deployment-outputs.json"
}

# Function to display summary
display_summary() {
    log_section "Deployment Summary"
    
    OUTPUTS="$PROJECT_ROOT/workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/deployment-outputs.json"
    
    if [ -f "$OUTPUTS" ]; then
        APP_SERVICE_URL=$(jq -r '.appServiceUrl.value' "$OUTPUTS")
        APP_SERVICE_NAME=$(jq -r '.appServiceName.value' "$OUTPUTS")
        SQL_SERVER_NAME=$(jq -r '.sqlServerName.value' "$OUTPUTS")
        KV_NAME=$(jq -r '.keyVaultName.value' "$OUTPUTS")
        STORAGE_NAME=$(jq -r '.storageAccountName.value' "$OUTPUTS")
        
        echo ""
        echo "Workload: $WORKLOAD_NAME"
        echo "Environment: $ENVIRONMENT"
        echo "Location: $LOCATION"
        echo ""
        echo "Resources deployed:"
        echo "  App Service: $APP_SERVICE_NAME"
        echo "  App Service URL: $APP_SERVICE_URL"
        echo "  SQL Server: $SQL_SERVER_NAME"
        echo "  Key Vault: $KV_NAME"
        echo "  Storage Account: $STORAGE_NAME"
        echo ""
    fi
    
    log_info "========================================"
    log_info "✅ Workload Landing Zone deployed!"
    log_info "========================================"
    echo ""
    
    log_warn "NEXT STEPS:"
    echo "1. Deploy your application code to App Service"
    echo "2. Configure custom domain and SSL certificate"
    echo "3. Populate the database with schema and data"
    echo "4. Configure monitoring alerts"
    echo "5. Test the application end-to-end"
    echo ""
    
    log_warn "IMPORTANT:"
    echo "SQL Password saved in: workloads/${WORKLOAD_NAME}-${ENVIRONMENT}/.sql-password"
    echo "Store this password securely in Key Vault or password manager!"
    echo ""
}

# ==============================================
# MAIN EXECUTION
# ==============================================

log_section "Workload Landing Zone Deployment"
echo "Organization: $ORGANIZATION_NAME"
echo "Workload: $WORKLOAD_NAME"
echo "Environment: $ENVIRONMENT"
echo "Location: $LOCATION"
echo ""

# Confirm deployment
read -p "Continue with deployment? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_warn "Deployment cancelled by user"
    exit 0
fi

# Execute deployment steps
check_prerequisites
validate_dependencies
create_private_dns_zones
generate_parameters
validate_deployment
deploy_workload
display_summary

exit 0