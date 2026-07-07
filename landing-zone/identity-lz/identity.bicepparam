// landing-zone/identity-lz/identity.bicepparam

using './identity.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// Doit avoir été créé au préalable
param identityResourceGroupName = 'rg-${organizationName}-${environment}-${location}-identity'

// Subscription IDs
param prodSubscriptionId = '0061dc3e-7704-4778-bcda-b566d000d486'
// param loggingSubscriptionId = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
// param quarantineSubscriptionId = 'cccccccc-cccc-cccc-cccc-cccccccccccc'

// Entra ID Group IDs (from create_entra_groups_script.sh output)
// Load these from the JSON file created by the script
param entraGroupIds = {
  platformAdmins: '9c69ec76-4d23-4c8f-be44-306fc8673b60'
  platformContributors: '432f270a-b5d8-45fc-9324-b37471b0a24d'
  networkAdmins: 'ebb9bc11-ba5f-4b2d-af04-6c47e28c8c92'
  securityAdmins: 'f5e67f5c-38a2-4b72-8db7-c23bb78c7aac'
  costManagers: 'bac387dd-a547-47c9-b217-14af468d1f35'
  billingReaders: '67e47d83-f490-4209-8abd-3b47c6570d94'
  prodAdmins: 'd7d50802-11f2-42e0-850e-d532f82df564'
  prodContributors: 'b654a1c7-61cd-48a1-9aa4-591aa759dc1c'
  prodReaders: 'fcecfe9f-2595-43a1-bc13-a487bd28f7ef'
  loggingAdmins: '70da0ac4-38a1-4765-8ec2-a2c72213a8fc'
  loggingContributors: 'f0f42fd0-4a77-4982-861a-602ce9230f0e'
  loggingReaders: 'db913e51-0655-422f-90a8-864c33924551'
  quarantineAdmins: '287a5e73-2ff7-49e8-879e-79ae8fbc3541'
  quarantineContributors: '7f0a8a13-ac35-4027-a513-8cd209b8ba3e'
  quarantineReaders: 'd903c771-8ae2-4283-9b0e-e610dabd34be'
  // appDevelopers: 'dddddddd-dddd-dddd-dddd-dddddddddddd'
  // appDeployers: 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
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
