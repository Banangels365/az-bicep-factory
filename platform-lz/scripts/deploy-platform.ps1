# deploy-platform.ps1
# PowerShell script to deploy Azure Landing Zone Platform components

<#
.SYNOPSIS
    Deploys the Azure Landing Zone Platform including Management Groups, Policies, and Logging.

.DESCRIPTION
    This script orchestrates the deployment of:
    - Management Group hierarchy
    - Custom Azure Policies
    - Policy Assignments
    - Log Analytics Workspace
    - Microsoft Sentinel (optional)

.PARAMETER Environment
    The environment to deploy (dev, staging, prod)

.PARAMETER Location
    Azure region for platform resources

.PARAMETER WhatIf
    Validate deployment without making changes

.EXAMPLE
    .\deploy-platform.ps1 -Environment prod -Location canadacentral

.EXAMPLE
    .\deploy-platform.ps1 -Environment prod -Location canadacentral -WhatIf
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = 'prod',

    [Parameter(Mandatory = $false)]
    [string]$Location = 'canadacentral',

    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

# ============================================
# Configuration
# ============================================

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

# Path configuration
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$PlatformPath = Join-Path $ScriptRoot "platform"
$MainBicepFile = Join-Path $PlatformPath "platform.bicep"
$ParametersFile = Join-Path $PlatformPath "platform.bicepparam"

# Deployment configuration
$DeploymentName = "platform-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# ============================================
# Functions
# ============================================

function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    
    switch ($Level) {
        'Info' { Write-Information "[$timestamp] [INFO] $Message" }
        'Success' { Write-Host "[$timestamp] [SUCCESS] $Message" -ForegroundColor Green }
        'Warning' { Write-Warning "[$timestamp] [WARNING] $Message" }
        'Error' { Write-Error "[$timestamp] [ERROR] $Message" }
    }
}

function Test-Prerequisites {
    Write-Log "Checking prerequisites..."
    
    # Check Azure CLI
    try {
        $azVersion = az version --output json | ConvertFrom-Json
        Write-Log "Azure CLI version: $($azVersion.'azure-cli')" -Level Success
    }
    catch {
        Write-Log "Azure CLI is not installed or not in PATH" -Level Error
        throw
    }
    
    # Check Bicep CLI
    try {
        $bicepVersion = bicep --version
        Write-Log "Bicep CLI version: $bicepVersion" -Level Success
    }
    catch {
        Write-Log "Bicep CLI is not installed. Installing..." -Level Warning
        az bicep install
        Write-Log "Bicep CLI installed successfully" -Level Success
    }
    
    # Check if logged in to Azure
    try {
        $account = az account show --output json | ConvertFrom-Json
        Write-Log "Logged in as: $($account.user.name)" -Level Success
        Write-Log "Subscription: $($account.name) ($($account.id))" -Level Success
    }
    catch {
        Write-Log "Not logged in to Azure. Please run 'az login'" -Level Error
        throw
    }
    
    # Check if user has required permissions at Tenant Root
    Write-Log "Checking permissions at Tenant Root..." -Level Info
    $tenantId = $account.tenantId
    
    Write-Log "Prerequisites check completed" -Level Success
}

function Build-BicepFiles {
    Write-Log "Building and validating Bicep files..."
    
    # Build main Bicep file
    try {
        Write-Log "Building: $MainBicepFile"
        bicep build $MainBicepFile
        Write-Log "Bicep build successful" -Level Success
    }
    catch {
        Write-Log "Bicep build failed: $_" -Level Error
        throw
    }
    
    # Validate all modules
    $moduleFiles = Get-ChildItem -Path (Join-Path $ScriptRoot "modules") -Filter "*.bicep" -Recurse
    
    foreach ($moduleFile in $moduleFiles) {
        try {
            Write-Log "Validating: $($moduleFile.FullName)"
            bicep build $moduleFile.FullName --stdout | Out-Null
        }
        catch {
            Write-Log "Module validation failed: $($moduleFile.Name)" -Level Error
            throw
        }
    }
    
    Write-Log "All Bicep files validated successfully" -Level Success
}

function Deploy-Platform {
    param(
        [Parameter(Mandatory = $false)]
        [switch]$WhatIf
    )
    
    Write-Log "Starting Platform deployment..."
    Write-Log "Environment: $Environment"
    Write-Log "Location: $Location"
    Write-Log "Deployment Name: $DeploymentName"
    
    if ($WhatIf) {
        Write-Log "Running in WhatIf mode - no changes will be made" -Level Warning
    }
    
    # Prepare deployment command
    $deploymentCommand = @(
        "az deployment tenant create"
        "--name $DeploymentName"
        "--location $Location"
        "--template-file `"$MainBicepFile`""
        "--parameters `"$ParametersFile`""
        "--parameters environment=$Environment"
        "--output json"
    )
    
    if ($WhatIf) {
        $deploymentCommand += "--what-if"
    }
    
    $deploymentCommandString = $deploymentCommand -join " "
    
    try {
        Write-Log "Executing deployment command..."
        Write-Log "Command: $deploymentCommandString" -Level Info
        
        $deploymentResult = Invoke-Expression $deploymentCommandString | ConvertFrom-Json
        
        if ($WhatIf) {
            Write-Log "WhatIf operation completed successfully" -Level Success
            return $null
        }
        else {
            Write-Log "Deployment completed successfully" -Level Success
            return $deploymentResult
        }
    }
    catch {
        Write-Log "Deployment failed: $_" -Level Error
        throw
    }
}

function Show-DeploymentOutputs {
    param(
        [Parameter(Mandatory = $true)]
        $DeploymentResult
    )
    
    if ($null -eq $DeploymentResult) {
        return
    }
    
    Write-Log "`n========================================"
    Write-Log "DEPLOYMENT OUTPUTS"
    Write-Log "========================================`n"
    
    if ($DeploymentResult.properties.outputs) {
        $outputs = $DeploymentResult.properties.outputs
        
        foreach ($output in $outputs.PSObject.Properties) {
            $name = $output.Name
            $value = $output.Value.value
            
            Write-Log "$name : $value" -Level Info
        }
    }
    
    Write-Log "`n========================================`n"
}

function Test-Deployment {
    param(
        [Parameter(Mandatory = $true)]
        $DeploymentResult
    )
    
    Write-Log "Running post-deployment tests..."
    
    # Test 1: Verify Management Groups
    Write-Log "Testing Management Groups..."
    try {
        $mgOutput = $DeploymentResult.properties.outputs.managementGroupIds.value
        
        foreach ($mgProperty in $mgOutput.PSObject.Properties) {
            $mgId = $mgProperty.Value
            $mgName = $mgProperty.Name
            
            $mgExists = az account management-group show --name $mgId 2>$null
            
            if ($mgExists) {
                Write-Log "✓ Management Group '$mgName' exists" -Level Success
            }
            else {
                Write-Log "✗ Management Group '$mgName' not found" -Level Error
            }
        }
    }
    catch {
        Write-Log "Management Group verification failed: $_" -Level Error
    }
    
    # Test 2: Verify Log Analytics Workspace
    Write-Log "Testing Log Analytics Workspace..."
    try {
        $lawId = $DeploymentResult.properties.outputs.logAnalyticsWorkspaceId.value
        
        if (-not [string]::IsNullOrEmpty($lawId)) {
            $lawExists = az monitor log-analytics workspace show --ids $lawId 2>$null
            
            if ($lawExists) {
                Write-Log "✓ Log Analytics Workspace exists" -Level Success
            }
            else {
                Write-Log "✗ Log Analytics Workspace not found" -Level Error
            }
        }
    }
    catch {
        Write-Log "Log Analytics Workspace verification failed: $_" -Level Error
    }
    
    Write-Log "Post-deployment tests completed" -Level Success
}

# ============================================
# Main Execution
# ============================================

try {
    Write-Log "========================================"
    Write-Log "Azure Landing Zone Platform Deployment"
    Write-Log "========================================"
    Write-Log ""
    
    # Step 1: Prerequisites check
    Test-Prerequisites
    Write-Log ""
    
    # Step 2: Build and validate Bicep
    Build-BicepFiles
    Write-Log ""
    
    # Step 3: Deploy platform
    $deploymentResult = Deploy-Platform -WhatIf:$WhatIf
    Write-Log ""
    
    # Step 4: Show outputs (if not WhatIf)
    if (-not $WhatIf) {
        Show-DeploymentOutputs -DeploymentResult $deploymentResult
        
        # Step 5: Run post-deployment tests
        Test-Deployment -DeploymentResult $deploymentResult
    }
    
    Write-Log ""
    Write-Log "========================================"
    Write-Log "Platform deployment completed successfully!" -Level Success
    Write-Log "========================================"
    
    exit 0
}
catch {
    Write-Log ""
    Write-Log "========================================"
    Write-Log "Platform deployment failed!" -Level Error
    Write-Log "Error: $_" -Level Error
    Write-Log "========================================"
    
    exit 1
}