#!/bin/bash
# This script deploys all landing zones in the correct order with the appropriate parameters.
# It assumes that you have already logged in to Azure CLI and set the correct subscription context.

# 1. Platform Landing Zone
cd platform
./scripts/deploy-platform.ps1 -Environment sandbox -Location canadacentral

# 2. Connectivity Landing Zone
cd ../connectivity/hub
az deployment sub create \
  --name hub-deployment \
  --location canadacentral \
  --template-file main.bicep \
  --parameters main.bicepparam

# 3. Identity Landing Zone
cd ../../scripts
./deploy-identity-complete.sh

# 4. Workload Landing Zone
export WORKLOAD_NAME="crm"
export ENVIRONMENT="prod"
./deploy-workload.sh