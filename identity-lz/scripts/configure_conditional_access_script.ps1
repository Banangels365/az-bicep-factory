# identity-lz/scripts/configure_conditional_access_script.ps1
# Script to configure Conditional Access Policies using Microsoft Graph

<#
.SYNOPSIS
    Creates and configures Conditional Access Policies for Azure AD.

.DESCRIPTION
    This script creates standard Conditional Access policies including:
    - Require MFA for administrators
    - Require MFA for all users
    - Block legacy authentication
    - Require compliant devices
    - Require approved apps for mobile access

.NOTES
    Requires Microsoft.Graph PowerShell module and appropriate permissions
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$OrganizationName = "ACMY",

    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

# Color functions
function Write-ColorOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    
    switch ($Level) {
        'Info' { Write-Host "[$timestamp] [INFO] $Message" -ForegroundColor Cyan }
        'Success' { Write-Host "[$timestamp] [SUCCESS] $Message" -ForegroundColor Green }
        'Warning' { Write-Host "[$timestamp] [WARNING] $Message" -ForegroundColor Yellow }
        'Error' { Write-Host "[$timestamp] [ERROR] $Message" -ForegroundColor Red }
    }
}

# ==============================================
# CHECK PREREQUISITES
# ==============================================

Write-ColorOutput "========================================" -Level Info
Write-ColorOutput "Conditional Access Policy Configuration" -Level Info
Write-ColorOutput "========================================" -Level Info
Write-Host ""

# Check if Microsoft Graph module is installed
Write-ColorOutput "Checking prerequisites..." -Level Info

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-ColorOutput "Microsoft.Graph module not found. Installing..." -Level Warning
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

# Import required modules
Import-Module Microsoft.Graph.Identity.SignIns
Import-Module Microsoft.Graph.Groups

# Connect to Microsoft Graph
Write-ColorOutput "Connecting to Microsoft Graph..." -Level Info

try {
    Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess", "Group.Read.All", "Application.Read.All"
    Write-ColorOutput "Successfully connected to Microsoft Graph" -Level Success
}
catch {
    Write-ColorOutput "Failed to connect to Microsoft Graph: $_" -Level Error
    exit 1
}

# ==============================================
# GET REQUIRED GROUP IDs
# ==============================================

Write-ColorOutput "Retrieving Entra ID groups..." -Level Info

try {
    # Get admin groups
    $adminGroups = @(
        "${OrganizationName}-Platform-Admins",
        "${OrganizationName}-Security-Admins",
        "${OrganizationName}-Network-Admins"
    )
    
    $adminGroupIds = @()
    foreach ($groupName in $adminGroups) {
        $group = Get-MgGroup -Filter "displayName eq '$groupName'" -ErrorAction SilentlyContinue
        if ($group) {
            $adminGroupIds += $group.Id
            Write-ColorOutput "Found group: $groupName (ID: $($group.Id))" -Level Info
        }
        else {
            Write-ColorOutput "Group not found: $groupName" -Level Warning
        }
    }
    
    # Get exclusion groups (break-glass accounts)
    $breakGlassGroup = Get-MgGroup -Filter "displayName eq 'CA-BreakGlass-Exclusions'" -ErrorAction SilentlyContinue
    $breakGlassGroupId = if ($breakGlassGroup) { $breakGlassGroup.Id } else { $null }
    
    if (-not $breakGlassGroupId) {
        Write-ColorOutput "Creating CA-BreakGlass-Exclusions group..." -Level Warning
        $newGroup = New-MgGroup -DisplayName "CA-BreakGlass-Exclusions" `
            -MailEnabled:$false `
            -MailNickname "ca-breakglass" `
            -SecurityEnabled:$true `
            -Description "Exclusion group for Conditional Access - Emergency access accounts"
        $breakGlassGroupId = $newGroup.Id
        Write-ColorOutput "Created break-glass exclusion group (ID: $breakGlassGroupId)" -Level Success
    }
}
catch {
    Write-ColorOutput "Error retrieving groups: $_" -Level Error
    exit 1
}

# ==============================================
# HELPER FUNCTIONS
# ==============================================

function New-ConditionalAccessPolicy {
    param(
        [string]$DisplayName,
        [hashtable]$Conditions,
        [hashtable]$GrantControls,
        [string]$State = "enabledForReportingButNotEnforced"
    )
    
    Write-ColorOutput "Creating policy: $DisplayName" -Level Info
    
    # Check if policy already exists
    $existingPolicy = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq '$DisplayName'" -ErrorAction SilentlyContinue
    
    if ($existingPolicy) {
        Write-ColorOutput "Policy '$DisplayName' already exists. Skipping." -Level Warning
        return $existingPolicy
    }
    
    if ($WhatIf) {
        Write-ColorOutput "[WHATIF] Would create policy: $DisplayName" -Level Info
        return $null
    }
    
    try {
        $policyParams = @{
            DisplayName   = $DisplayName
            State         = $State
            Conditions    = $Conditions
            GrantControls = $GrantControls
        }
        
        $policy = New-MgIdentityConditionalAccessPolicy -BodyParameter $policyParams
        Write-ColorOutput "Successfully created policy: $DisplayName (ID: $($policy.Id))" -Level Success
        return $policy
    }
    catch {
        Write-ColorOutput "Failed to create policy '$DisplayName': $_" -Level Error
        return $null
    }
}

# ==============================================
# CREATE CONDITIONAL ACCESS POLICIES
# ==============================================

Write-Host ""
Write-ColorOutput "========================================" -Level Info
Write-ColorOutput "Creating Conditional Access Policies" -Level Info
Write-ColorOutput "========================================" -Level Info
Write-Host ""

# ----- POLICY 1: Require MFA for Administrators -----
Write-ColorOutput "Policy 1: Require MFA for Administrators" -Level Info

$policy1Conditions = @{
    Applications = @{
        IncludeApplications = @("All")
    }
    Users        = @{
        IncludeGroups = $adminGroupIds
        ExcludeGroups = @($breakGlassGroupId)
    }
}

$policy1Grant = @{
    Operator        = "OR"
    BuiltInControls = @("mfa")
}

$policy1 = New-ConditionalAccessPolicy `
    -DisplayName "CA001: Require MFA for Administrators" `
    -Conditions $policy1Conditions `
    -GrantControls $policy1Grant `
    -State "enabled"

# ----- POLICY 2: Require MFA for All Users -----
Write-ColorOutput "Policy 2: Require MFA for All Users" -Level Info

$policy2Conditions = @{
    Applications   = @{
        IncludeApplications = @("All")
    }
    Users          = @{
        IncludeUsers  = @("All")
        ExcludeGroups = @($breakGlassGroupId)
    }
    ClientAppTypes = @("browser", "mobileAppsAndDesktopClients")
}

$policy2Grant = @{
    Operator        = "OR"
    BuiltInControls = @("mfa")
}

$policy2 = New-ConditionalAccessPolicy `
    -DisplayName "CA002: Require MFA for All Users" `
    -Conditions $policy2Conditions `
    -GrantControls $policy2Grant `
    -State "enabledForReportingButNotEnforced"  # Start in report-only mode

# ----- POLICY 3: Block Legacy Authentication -----
Write-ColorOutput "Policy 3: Block Legacy Authentication" -Level Info

$policy3Conditions = @{
    Applications   = @{
        IncludeApplications = @("All")
    }
    Users          = @{
        IncludeUsers  = @("All")
        ExcludeGroups = @($breakGlassGroupId)
    }
    ClientAppTypes = @("exchangeActiveSync", "other")
}

$policy3Grant = @{
    Operator        = "OR"
    BuiltInControls = @("block")
}

$policy3 = New-ConditionalAccessPolicy `
    -DisplayName "CA003: Block Legacy Authentication" `
    -Conditions $policy3Conditions `
    -GrantControls $policy3Grant `
    -State "enabled"

# ----- POLICY 4: Require Compliant or Hybrid Joined Device -----
Write-ColorOutput "Policy 4: Require Compliant Device" -Level Info

$policy4Conditions = @{
    Applications = @{
        IncludeApplications = @("Office365")
    }
    Users        = @{
        IncludeUsers  = @("All")
        ExcludeGroups = @($breakGlassGroupId)
    }
    Platforms    = @{
        IncludePlatforms = @("windows", "macOS")
    }
}

$policy4Grant = @{
    Operator        = "OR"
    BuiltInControls = @("compliantDevice", "domainJoinedDevice")
}

$policy4 = New-ConditionalAccessPolicy `
    -DisplayName "CA004: Require Compliant or Hybrid Joined Device" `
    -Conditions $policy4Conditions `
    -GrantControls $policy4Grant `
    -State "enabledForReportingButNotEnforced"

# ----- POLICY 5: Require Approved App for Mobile -----
Write-ColorOutput "Policy 5: Require Approved App for Mobile Access" -Level Info

$policy5Conditions = @{
    Applications = @{
        IncludeApplications = @("Office365")
    }
    Users        = @{
        IncludeUsers  = @("All")
        ExcludeGroups = @($breakGlassGroupId)
    }
    Platforms    = @{
        IncludePlatforms = @("iOS", "android")
    }
}

$policy5Grant = @{
    Operator        = "OR"
    BuiltInControls = @("approvedApplication")
}

$policy5 = New-ConditionalAccessPolicy `
    -DisplayName "CA005: Require Approved App for Mobile Access" `
    -Conditions $policy5Conditions `
    -GrantControls $policy5Grant `
    -State "enabledForReportingButNotEnforced"

# ----- POLICY 6: Block Access from Unknown Locations -----
Write-ColorOutput "Policy 6: Block Access from Unknown Locations" -Level Info

# Note: This requires named locations to be configured separately
$policy6Conditions = @{
    Applications = @{
        IncludeApplications = @("All")
    }
    Users        = @{
        IncludeUsers  = @("All")
        ExcludeGroups = @($breakGlassGroupId)
    }
    Locations    = @{
        IncludeLocations = @("All")
        ExcludeLocations = @("AllTrusted")
    }
}

$policy6Grant = @{
    Operator        = "AND"
    BuiltInControls = @("mfa")
}

$policy6 = New-ConditionalAccessPolicy `
    -DisplayName "CA006: Require MFA from Untrusted Locations" `
    -Conditions $policy6Conditions `
    -GrantControls $policy6Grant `
    -State "enabledForReportingButNotEnforced"

# ==============================================
# SUMMARY
# ==============================================

Write-Host ""
Write-ColorOutput "========================================" -Level Success
Write-ColorOutput "✅ Conditional Access Configuration Complete!" -Level Success
Write-ColorOutput "========================================" -Level Success
Write-Host ""

Write-ColorOutput "Created/Updated Policies:" -Level Info
Write-ColorOutput "  CA001: Require MFA for Administrators (Enabled)" -Level Info
Write-ColorOutput "  CA002: Require MFA for All Users (Report-Only)" -Level Info
Write-ColorOutput "  CA003: Block Legacy Authentication (Enabled)" -Level Info
Write-ColorOutput "  CA004: Require Compliant Device (Report-Only)" -Level Info
Write-ColorOutput "  CA005: Require Approved App for Mobile (Report-Only)" -Level Info
Write-ColorOutput "  CA006: Require MFA from Untrusted Locations (Report-Only)" -Level Info
Write-Host ""

Write-ColorOutput "⚠️  IMPORTANT NEXT STEPS:" -Level Warning
Write-ColorOutput "1. Review report-only policies in Azure Portal" -Level Info
Write-ColorOutput "2. Configure Named Locations for geo-blocking" -Level Info
Write-ColorOutput "3. Test policies with pilot group before enabling" -Level Info
Write-ColorOutput "4. Add emergency access accounts to CA-BreakGlass-Exclusions group" -Level Info
Write-ColorOutput "5. Monitor sign-in logs for unexpected blocks" -Level Info
Write-ColorOutput "6. Enable remaining policies after validation" -Level Info

# Disconnect from Microsoft Graph
Disconnect-MgGraph

exit 0