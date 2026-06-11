/*
03_Network_Policy.bicep - Initiative regroupant 2 policies intégrées (built-ins) liées à la sécurité réseau

Initiative (subscription) + assignation

Inclut 2 built-ins :
  1) Subnets should be associated with a Network Security Group (AuditIfNotExists)
     ID : e71308d3-144b-4262-b144-efdc3cc90517

     Description de la policy 
     Protect your subnet from potential threats by restricting access to it with a
     Network Security Group (NSG). NSGs contain a list of Access Control List (ACL) rules
     that allow or deny network traffic to your subnet.

  2) Network interfaces should not have public IPs (Deny)
     ID : 83a86a26-fd1f-447c-b59d-e51f44264114

     Description de la policy
     This policy denies the network interfaces which are configured with any public IP.
     Public IP addresses allow internet resources to communicate inbound to Azure resources,
     and Azure resources to communicate outbound to the internet. This should be reviewed 
     by the network security team.


IMPORTANT : Chaque entrée policyDefinitions possède un policyDefinitionReferenceId.
Les nonComplianceMessages de l’assignation pointent vers ces IDs.
*/

targetScope = 'managementGroup'

// ---------------------------
// Paramètres
// ---------------------------
@description('Nom de l\'initiative (policy set) à créer.')
param initiativeName string

@description('Nom de l\'assignation de l\'initiative.')
param assignmentName string

@description('Nom lisible pour l\'initiative.')
param initiativeDisplayName string

@description('Nom lisible pour l\'assignation.')
param assignmentDisplayName string

@description('Catégorie de l\'initiative (metadata.category).')
@allowed([
  'General'
  'Network'
  'Security'
  'Compliance'
])
param initiativeCategory string = 'General'

@description('Enforcement mode pour l\'assignation (Default = actif, DoNotEnforce = n\'applique pas).')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

// ---------------------------
// Définition de l’initiative
// ---------------------------
resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: initiativeName
  properties: {
    displayName: initiativeDisplayName
    description: '03-Network - Subnets with NSG + NICs without Public IPs'
    policyType: 'Custom'
    metadata: {
      category: initiativeCategory
      version: '1.0.1'
    }

    // Pas de paramètres d’initiative pour ces deux built-ins
    parameters: {}

    // Chaque policy possède un policyDefinitionReferenceId UNIQUE
    policyDefinitions: [
      {
        // Built-in: Subnets should be associated with a Network Security Group (AuditIfNotExists)
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517'
        policyDefinitionReferenceId: 'ref-subnet-nsg'
      }
      {
        // Built-in: Network interfaces should not have public IPs (Deny)
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
        policyDefinitionReferenceId: 'ref-nic-no-publicip'
      }
    ]
  }
}

// ---------------------------
// Assignation de l’initiative
// ---------------------------
resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: assignmentName
  //scope: subscription()
  properties: {
    displayName: assignmentDisplayName
    description: '03-Network - Assignment: Subnets with NSG + No Public IPs on NICs'
    policyDefinitionId: initiative.id

    // Pas de paramètres (policies sans paramètres)
    parameters: {}

    // Un message par policy, chacun référencé
    nonComplianceMessages: [
      {
        policyDefinitionReferenceId: 'ref-subnet-nsg'
        message: 'Les subnets doivent être associés à un NSG.'
      }
      {
        policyDefinitionReferenceId: 'ref-nic-no-publicip'
        message: 'Les cartes réseau (NIC) ne doivent pas avoir d\'adresse IP publique.'
      }
    ]

    enforcementMode: enforcementMode
  }
}

// ---------------------------
// Sorties
// ---------------------------
output initiativeId string = initiative.id
output assignmentId string = initiativeAssignment.id
