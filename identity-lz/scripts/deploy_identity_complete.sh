#!/bin/bash
# identity-lz/scripts/deploy_identity_complete.sh
# Master script to deploy complete Identity Landing Zone

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ORGANIZATION_NAME="${ORGANIZATION_NAME:-contoso}"
ENVIRONMENT="${ENVIRONMENT:-prod}"
LOCATION="${LOCATION:-canadacentral}"

# Subscription IDs
MANAGEMENT_SUBSCRIPTION_ID="${MANAGEMENT_SUBSCRIPTION_ID:-}"
DEV_SUBSCRIPTION_ID="${DEV_SUBSCRIPTION_ID:-}"
STAGING_SUBSCRIPTION_ID="${STAGING_SUBSCRIPTION_ID:-}"
PROD_SUBSCRIPTION_ID="${PROD_SUBSCRIPTION_ID:-}"

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
        log_error "Azure CLI not found. Please install: https://docs.microsoft.com/cli/azure/install-azure-cli"
        exit 1
    fi
    log_info "✓ Azure CLI installed: $(az version --query '\"azure-cli\"' -o tsv)"
    
    # Check PowerShell
    if ! command -v pwsh &> /dev/null; then
        log_warn "PowerShell 7+ not found. Conditional Access configuration will be skipped."
        SKIP_CONDITIONAL_ACCESS=true
    else
        log_info "✓ PowerShell installed: $(pwsh --version)"
    fi
    
    # Check Bicep
    if ! command -v bicep &> /dev/null; then
        log_warn "Bicep CLI not found. Installing..."
        az bicep install
    fi
    log_info "✓ Bicep CLI installed: $(bicep --version)"
    
    # Check if logged in
    if ! az account show &> /dev/null; then
        log_error "Not logged in to Azure. Please run 'az login'"
        exit 1
    fi
    
    CURRENT_USER=$(az account show --query user.name -o tsv)
    CURRENT_SUBSCRIPTION=$(az account show --query name -o tsv)
    log_info "✓ Logged in as: $CURRENT_USER"
    log_info "✓ Current subscription: $CURRENT_SUBSCRIPTION"
    
    # Validate subscription IDs
    if [ -z "$MANAGEMENT_SUBSCRIPTION_ID" ]; then
        log_warn "MANAGEMENT_SUBSCRIPTION_ID not set, using current subscription"
        MANAGEMENT_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    fi
    
    log_info "Management Subscription: $MANAGEMENT_SUBSCRIPTION_ID"
}

# Function to create Entra ID groups
create_entra_groups() {
    log_section "Step 1: Creating Entra ID Groups"
    
    cd "$SCRIPT_DIR/identity"
    
    if [ ! -f "create-entra-groups.sh" ]; then
        log_error "Script create-entra-groups.sh not found"
        exit 1
    fi
    
    chmod +x create-entra-groups.sh
    
    export ORGANIZATION_NAME
    export ENVIRONMENT
    
    ./create-entra-groups.sh
    
    if [ $? -ne 0 ]; then
        log_error "Failed to create Entra ID groups"
        exit 1
    fi
    
    log_info "✓ Entra ID groups created successfully"
    
    # Check if output file exists
    if [ ! -f "$SCRIPT_DIR/identity/output/entra-groups.json" ]; then
        log_error "Group IDs output file not found"
        exit 1
    fi
    
    cd "$PROJECT_ROOT"
}

# Function to create service principals
create_service_principals() {
    log_section "Step 2: Creating Service Principals"
    
    cd "$SCRIPT_DIR/identity"
    
    if [ ! -f "create-service-principals.sh" ]; then
        log_error "Script create-service-principals.sh not found"
        exit 1
    fi
    
    chmod +x create-service-principals.sh
    
    export ORGANIZATION_NAME
    export ENVIRONMENT
    export SUBSCRIPTION_ID=$MANAGEMENT_SUBSCRIPTION_ID
    
    ./create-service-principals.sh
    
    if [ $? -ne 0 ]; then
        log_error "Failed to create service principals"
        exit 1
    fi
    
    log_info "✓ Service principals created successfully"
    
    cd "$PROJECT_ROOT"
}

# Function to configure conditional access
configure_conditional_access() {
    if [ "$SKIP_CONDITIONAL_ACCESS" = true ]; then
        log_warn "Skipping Conditional Access configuration (PowerShell not found)"
        return
    fi
    
    log_section "Step 3: Configuring Conditional Access Policies"
    
    cd "$SCRIPT_DIR/identity"
    
    if [ ! -f "configure-conditional-access.ps1" ]; then
        log_error "Script configure-conditional-access.ps1 not found"
        exit 1
    fi
    
    pwsh -File configure-conditional-access.ps1 -OrganizationName "$ORGANIZATION_NAME"
    
    if [ $? -ne 0 ]; then
        log_error "Failed to configure Conditional Access"
        exit 1
    fi
    
    log_info "✓ Conditional Access policies configured successfully"
    
    cd "$PROJECT_ROOT"
}

# Function to prepare Bicep parameters
prepare_bicep_parameters() {
    log_section "Step 4: Preparing Bicep Parameters"
    
    # Read group IDs from JSON file
    GROUP_IDS_FILE="$SCRIPT_DIR/identity/output/entra-groups.json"
    
    if [ ! -f "$GROUP_IDS_FILE" ]; then
        log_error "Group IDs file not found: $GROUP_IDS_FILE"
        exit 1
    fi
    
    log_info "Reading group IDs from $GROUP_IDS_FILE"
    
    # Create parameters file
    PARAMS_FILE="$PROJECT_ROOT/identity/main.bicepparam"
    
    cat > "$PARAMS_FILE" <<EOF
// identity/main.bicepparam
// Auto-generated by deploy-identity-complete.sh
using './main.bicep'

param organizationName = '$ORGANIZATION_NAME'
param environment = '$ENVIRONMENT'
param location = '$LOCATION'

param managementSubscriptionId = '$MANAGEMENT_SUBSCRIPTION_ID'
param devSubscriptionId = '${DEV_SUBSCRIPTION_ID:-$MANAGEMENT_SUBSCRIPTION_ID}'
param stagingSubscriptionId = '${STAGING_SUBSCRIPTION_ID:-$MANAGEMENT_SUBSCRIPTION_ID}'
param prodSubscriptionId = '${PROD_SUBSCRIPTION_ID:-$MANAGEMENT_SUBSCRIPTION_ID}'

param entraGroupIds = $(cat "$GROUP_IDS_FILE")

param tags = {
  Environment: '$ENVIRONMENT'
  ManagedBy: 'Bicep'
  CostCenter: 'IT-Identity'
  Owner: 'IdentityOps-Team'
  DeployedBy: '$(whoami)'
  DeployedAt: '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
}
EOF
    
    log_info "✓ Bicep parameters file created: $PARAMS_FILE"
}

# Function to deploy Bicep template
deploy_bicep() {
    log_section "Step 5: Deploying Managed Identities and RBAC"
    
    cd "$PROJECT_ROOT/identity"
    
    DEPLOYMENT_NAME="identity-deployment-$(date +%Y%m%d-%H%M%S)"
    
    log_info "Deployment name: $DEPLOYMENT_NAME"
    log_info "Template: main.bicep"
    log_info "Parameters: main.bicepparam"
    
    # Validate deployment
    log_info "Validating deployment..."
    az deployment sub validate \
        --name "$DEPLOYMENT_NAME" \
        --location "$LOCATION" \
        --template-file main.bicep \
        --parameters main.bicepparam
    
    if [ $? -ne 0 ]; then
        log_error "Deployment validation failed"
        exit 1
    fi
    
    log_info "✓ Deployment validation successful"
    
    # Deploy
    log_info "Starting deployment..."
    az deployment sub create \
        --name "$DEPLOYMENT_NAME" \
        --location "$LOCATION" \
        --template-file main.bicep \
        --parameters main.bicepparam
    
    if [ $? -ne 0 ]; then
        log_error "Deployment failed"
        exit 1
    fi
    
    log_info "✓ Deployment completed successfully"
    
    # Get outputs
    log_info "Retrieving deployment outputs..."
    az deployment sub show \
        --name "$DEPLOYMENT_NAME" \
        --query properties.outputs \
        -o json > "$SCRIPT_DIR/identity/output/deployment-outputs.json"
    
    log_info "✓ Deployment outputs saved to output/deployment-outputs.json"
    
    cd "$PROJECT_ROOT"
}

# Function to verify deployment
verify_deployment() {
    log_section "Step 6: Verifying Deployment"
    
    log_info "Checking Entra ID groups..."
    GROUP_COUNT=$(az ad group list --filter "startswith(displayName, '$ORGANIZATION_NAME')" --query "length(@)" -o tsv)
    log_info "✓ Found $GROUP_COUNT groups"
    
    log_info "Checking Service Principals..."
    SP_COUNT=$(az ad sp list --filter "startswith(displayName, 'sp-$ORGANIZATION_NAME')" --query "length(@)" -o tsv)
    log_info "✓ Found $SP_COUNT service principals"
    
    log_info "Checking Managed Identities..."
    MI_COUNT=$(az identity list --query "length([?contains(name, '$ORGANIZATION_NAME')])" -o tsv)
    log_info "✓ Found $MI_COUNT managed identities"
    
    log_info "Checking RBAC assignments..."
    # This is approximate as it checks all assignments in subscription
    RBAC_COUNT=$(az role assignment list --all --query "length([?contains(principalName, '$ORGANIZATION_NAME')])" -o tsv)
    log_info "✓ Found $RBAC_COUNT role assignments"
}

# Function to display summary
display_summary() {
    log_section "Deployment Summary"
    
    echo ""
    echo "Organization: $ORGANIZATION_NAME"
    echo "Environment: $ENVIRONMENT"
    echo "Location: $LOCATION"
    echo ""
    echo "Subscriptions:"
    echo "  Management: $MANAGEMENT_SUBSCRIPTION_ID"
    echo "  Dev: ${DEV_SUBSCRIPTION_ID:-N/A}"
    echo "  Staging: ${STAGING_SUBSCRIPTION_ID:-N/A}"
    echo "  Prod: ${PROD_SUBSCRIPTION_ID:-N/A}"
    echo ""
    echo "Output files:"
    echo "  Groups: $SCRIPT_DIR/identity/output/entra-groups.json"
    echo "  Service Principals: $SCRIPT_DIR/identity/output/service-principals.json"
    echo "  Deployment: $SCRIPT_DIR/identity/output/deployment-outputs.json"
    echo ""
    
    log_info "========================================"
    log_info "✅ Identity Landing Zone deployed successfully!"
    log_info "========================================"
    echo ""
    
    log_warn "NEXT STEPS:"
    echo "1. Review Conditional Access policies in report-only mode"
    echo "2. Add users to appropriate groups"
    echo "3. Configure break-glass accounts"
    echo "4. Enable remaining CA policies after testing"
    echo "5. Configure PIM for privileged roles"
    echo "6. Set up MFA for all users"
    echo ""
}

# ==============================================
# MAIN EXECUTION
# ==============================================

log_section "Identity Landing Zone Deployment"
echo "Organization: $ORGANIZATION_NAME"
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
create_entra_groups
create_service_principals
configure_conditional_access
prepare_bicep_parameters
deploy_bicep
verify_deployment
display_summary

exit 0