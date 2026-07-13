// landing-zone/platform-lz/platform.bicepparam

using './platform.bicep'

// Organization configuration
param organizationName = 'acmy'
param environment = 'sbox' // prod, dev, logs, quar, sbox
param location = 'caea' // canadacentral ou canadaeast

// billing scope ID for subscription creation
param managementSubscriptionId = '0061dc3e-7704-4778-bcda-b566d000d486'

// liste des tags à appliquer à toutes les ressources
param tags = {
  Application: 'Platform-LZ'
  Environnement: 'sbox'
  CreeLe: '2026-06-10'
  CreePar: 'CloudOps-Team'
  Criticite: 'Moyen'
  Responsable: 'CloudOps-Team'
  ResponsableEmail: 'cloudops@acmy.com'
}

// Logging configuration
// param logRetentionDays = 90
// param enableSentinel = true
