// identity-lz/identity.bicepparam
using './identity.bicep'

// Organization configuration
param organizationName = 'contoso'
param environment = 'prod'
param location = 'canadacentral'

// Subscription IDs
param managementSubscriptionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
param loggingSubscriptionId = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
param quarantineSubscriptionId = 'cccccccc-cccc-cccc-cccc-cccccccccccc'
param prodSubscriptionId = 'dddddddd-dddd-dddd-dddd-dddddddddddd'

// Entra ID Group IDs (from create-entra-groups.sh output)
// Load these from the JSON file created by the script
param entraGroupIds = {
  platformAdmins: '11111111-1111-1111-1111-111111111111'
  platformContributors: '22222222-2222-2222-2222-222222222222'
  networkAdmins: '33333333-3333-3333-3333-333333333333'
  securityAdmins: '44444444-4444-4444-4444-444444444444'
  devAdmins: '55555555-5555-5555-5555-555555555555'
  devContributors: '66666666-6666-6666-6666-666666666666'
  devReaders: '77777777-7777-7777-7777-777777777777'
  stagingAdmins: '88888888-8888-8888-8888-888888888888'
  stagingContributors: '99999999-9999-9999-9999-999999999999'
  prodAdmins: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  prodContributors: 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
  prodReaders: 'cccccccc-cccc-cccc-cccc-cccccccccccc'
  appDevelopers: 'dddddddd-dddd-dddd-dddd-dddddddddddd'
  appDeployers: 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
  dbAdmins: 'ffffffff-ffff-ffff-ffff-ffffffffffff'
  costManagers: '00000000-0000-0000-0000-000000000001'
  billingReaders: '00000000-0000-0000-0000-000000000002'
}

// Tagging
param tags = {
  Environment: 'Production'
  ManagedBy: 'Bicep'
  CostCenter: 'IT-Identity'
  Owner: 'IdentityOps-Team'
  Purpose: 'Identity-Management'
}
