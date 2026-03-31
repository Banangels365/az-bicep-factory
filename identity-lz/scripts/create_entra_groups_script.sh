#!/bin/bash
# identity-lz/scripts/create_entra_groups_script.sh
# Script to create and manage Entra ID (Azure AD) groups

set -e

# Configuration
ORGANIZATION_NAME="${ORGANIZATION_NAME:-contoso}"
ENVIRONMENT="${ENVIRONMENT:-prod}"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Function to check if group exists
group_exists() {
    local display_name=$1
    az ad group show --group "$display_name" &>/dev/null
    return $?
}

# Function to create or update a group
create_or_update_group() {
    local display_name=$1
    local mail_nickname=$2
    local description=$3
    
    log_info "Processing group: $display_name"
    
    if group_exists "$display_name"; then
        log_warn "Group '$display_name' already exists. Skipping creation."
        GROUP_ID=$(az ad group show --group "$display_name" --query id -o tsv)
    else
        log_info "Creating group: $display_name"
        GROUP_ID=$(az ad group create \
            --display-name "$display_name" \
            --mail-nickname "$mail_nickname" \
            --description "$description" \
            --query id -o tsv)
        
        if [ $? -eq 0 ]; then
            log_info "Successfully created group: $display_name (ID: $GROUP_ID)"
        else
            log_error "Failed to create group: $display_name"
            return 1
        fi
    fi
    
    echo "$GROUP_ID"
}

# Function to add members to a group
add_group_member() {
    local group_id=$1
    local member_id=$2
    
    # Check if member already in group
    is_member=$(az ad group member check \
        --group "$group_id" \
        --member-id "$member_id" \
        --query value -o tsv)
    
    if [ "$is_member" == "true" ]; then
        log_warn "Member $member_id already in group $group_id"
        return 0
    fi
    
    log_info "Adding member $member_id to group $group_id"
    az ad group member add \
        --group "$group_id" \
        --member-id "$member_id"
}

# ==============================================
# CREATE GROUPS BY FUNCTION
# ==============================================

log_info "========================================"
log_info "Creating Entra ID Groups"
log_info "Organization: $ORGANIZATION_NAME"
log_info "Environment: $ENVIRONMENT"
log_info "========================================"
echo ""

# ---- Platform Teams ----
log_info "Creating Platform Team Groups..."

PLATFORM_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Platform-Admins" \
    "${ORGANIZATION_NAME}-platform-admins" \
    "Platform administrators with full access to platform resources")

PLATFORM_CONTRIBUTORS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Platform-Contributors" \
    "${ORGANIZATION_NAME}-platform-contributors" \
    "Platform contributors with limited access to platform resources")

NETWORK_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Network-Admins" \
    "${ORGANIZATION_NAME}-network-admins" \
    "Network administrators managing connectivity and security")

SECURITY_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Security-Admins" \
    "${ORGANIZATION_NAME}-security-admins" \
    "Security administrators managing policies and compliance")

# ---- Environment-specific Groups ----
log_info "Creating Environment-specific Groups..."

DEV_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Dev-Admins" \
    "${ORGANIZATION_NAME}-dev-admins" \
    "Administrators for development environment")

DEV_CONTRIBUTORS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Dev-Contributors" \
    "${ORGANIZATION_NAME}-dev-contributors" \
    "Contributors for development environment")

DEV_READERS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Dev-Readers" \
    "${ORGANIZATION_NAME}-dev-readers" \
    "Read-only access for development environment")

STAGING_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Staging-Admins" \
    "${ORGANIZATION_NAME}-staging-admins" \
    "Administrators for staging environment")

STAGING_CONTRIBUTORS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Staging-Contributors" \
    "${ORGANIZATION_NAME}-staging-contributors" \
    "Contributors for staging environment")

PROD_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Prod-Admins" \
    "${ORGANIZATION_NAME}-prod-admins" \
    "Administrators for production environment")

PROD_CONTRIBUTORS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Prod-Contributors" \
    "${ORGANIZATION_NAME}-prod-contributors" \
    "Contributors for production environment")

PROD_READERS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Prod-Readers" \
    "${ORGANIZATION_NAME}-prod-readers" \
    "Read-only access for production environment")

# ---- Application-specific Groups ----
log_info "Creating Application-specific Groups..."

APP_DEVELOPERS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-App-Developers" \
    "${ORGANIZATION_NAME}-app-developers" \
    "Application developers")

APP_DEPLOYERS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-App-Deployers" \
    "${ORGANIZATION_NAME}-app-deployers" \
    "Application deployment team")

DB_ADMINS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-DB-Admins" \
    "${ORGANIZATION_NAME}-db-admins" \
    "Database administrators")

# ---- Cost Management Groups ----
log_info "Creating Cost Management Groups..."

COST_MANAGERS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Cost-Managers" \
    "${ORGANIZATION_NAME}-cost-managers" \
    "Cost management and optimization team")

BILLING_READERS_ID=$(create_or_update_group \
    "${ORGANIZATION_NAME}-Billing-Readers" \
    "${ORGANIZATION_NAME}-billing-readers" \
    "Read-only access to billing and cost information")

# ==============================================
# EXPORT GROUP IDs
# ==============================================

log_info ""
log_info "========================================"
log_info "Exporting Group IDs to file..."
log_info "========================================"

# Create output directory if it doesn't exist
mkdir -p ./output

# Export to JSON
cat > ./output/entra-groups.json <<EOF
{
  "platformAdmins": "$PLATFORM_ADMINS_ID",
  "platformContributors": "$PLATFORM_CONTRIBUTORS_ID",
  "networkAdmins": "$NETWORK_ADMINS_ID",
  "securityAdmins": "$SECURITY_ADMINS_ID",
  "devAdmins": "$DEV_ADMINS_ID",
  "devContributors": "$DEV_CONTRIBUTORS_ID",
  "devReaders": "$DEV_READERS_ID",
  "stagingAdmins": "$STAGING_ADMINS_ID",
  "stagingContributors": "$STAGING_CONTRIBUTORS_ID",
  "prodAdmins": "$PROD_ADMINS_ID",
  "prodContributors": "$PROD_CONTRIBUTORS_ID",
  "prodReaders": "$PROD_READERS_ID",
  "appDevelopers": "$APP_DEVELOPERS_ID",
  "appDeployers": "$APP_DEPLOYERS_ID",
  "dbAdmins": "$DB_ADMINS_ID",
  "costManagers": "$COST_MANAGERS_ID",
  "billingReaders": "$BILLING_READERS_ID"
}
EOF

# Export to Azure DevOps variables (if running in pipeline)
if [ -n "$SYSTEM_TEAMFOUNDATIONCOLLECTIONURI" ]; then
    echo "##vso[task.setvariable variable=platformAdminsId;isOutput=true]$PLATFORM_ADMINS_ID"
    echo "##vso[task.setvariable variable=devAdminsId;isOutput=true]$DEV_ADMINS_ID"
    echo "##vso[task.setvariable variable=prodAdminsId;isOutput=true]$PROD_ADMINS_ID"
fi

log_info "Group IDs exported to ./output/entra-groups.json"

log_info ""
log_info "========================================"
log_info "✅ All groups created successfully!"
log_info "========================================"

exit 0