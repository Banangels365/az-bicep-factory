// identity-lz/identity.bicepparam
using './identity.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// Doit avoir été créé au préalable
param identityResourceGroupName = 'rg-${organizationName}-${environment}-${location}-identity'

// Subscription IDs
param prodSubscriptionId = '0061dc3e-7704-4778-bcda-b566d000d486'
param loggingSubscriptionId = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
param quarantineSubscriptionId = 'cccccccc-cccc-cccc-cccc-cccccccccccc'

// Entra ID Group IDs (from create_entra_groups_script.sh output)
// Load these from the JSON file created by the script
param entraGroupIds = {
  platformAdmins: '11111111-1111-1111-1111-111111111111'
  platformContributors: '22222222-2222-2222-2222-222222222222'
  networkAdmins: '33333333-3333-3333-3333-333333333333'
  securityAdmins: '44444444-4444-4444-4444-444444444444'
  costManagers: '00000000-0000-0000-0000-000000000001'
  billingReaders: '00000000-0000-0000-0000-000000000002'
  prodAdmins: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  prodContributors: 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
  prodReaders: 'cccccccc-cccc-cccc-cccc-cccccccccccc'
  loggingAdmins: '55555555-5555-5555-5555-555555555555'
  loggingContributors: '66666666-6666-6666-6666-666666666666'
  loggingReaders: '77777777-7777-7777-7777-777777777777'
  quarantineAdmins: '88888888-8888-8888-8888-888888888888'
  quarantineContributors: '99999999-9999-9999-9999-999999999999'
  quarantineReaders: '00000000-0000-0000-0000-000000000000'
  appDevelopers: 'dddddddd-dddd-dddd-dddd-dddddddddddd'
  appDeployers: 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
}

// Tagging
param tags = {
  Application: 'Identity-LZ'
  Environnement: 'sbox'
  CreeLe: '2024-05-24'
  CreePar: 'Bicep'
  Criticite: 'Moyen'
  Responsable: 'CloudOps-Team'
  ResponsableEmail: 'cloudops@acmy.com'
  Purpose: 'Identity-Management'
}
