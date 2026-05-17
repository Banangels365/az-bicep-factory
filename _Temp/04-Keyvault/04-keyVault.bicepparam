using './04-keyVault.bicep'

param initiativeName = '04-Keyvault-RBAC-Initiative'
param assignmentName = '04-Key-RBAC-Assignment' //ne doit pas depasse 24 characteres
param initiativeDisplayName = '04-Keyvault-RBAC-Initiative'
param assignmentDisplayName = '04-Keyvault-RBAC-Assignment'
param kvRbacEffect = 'Audit'

