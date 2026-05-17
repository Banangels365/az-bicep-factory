
Connect-AzAccount -Subscription 'f8d17dee-320f-4765-a0df-a0251ececb1a'

$Context = Get-AzSubscription -SubscriptionId "f8d17dee-320f-4765-a0df-a0251ececb1a"
Set-AzContext $context 
Get-AzResourceGroup  -Name 'rg-bicep02' 


# déploie au niveau du Management Group "Tenant Root Group"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
New-AzManagementGroupDeployment `
  -ManagementGroupId '4e504624-9abd-4371-aa47-31f0626f32d0' `
  -location "Canada Central" `
  -Name deploy_$Timestamp `
  -TemplateFile '.\main.bicep' `
  -TemplateParameterFile .\main.bicepparam `
  -verbose


      # déploie au niveau du Management Group "Tenant Root Group"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
New-AzManagementGroupDeployment `
  -ManagementGroupId '4e504624-9abd-4371-aa47-31f0626f32d0' `
  -location "Canada Central" `
  -Name deploy_$Timestamp `
  -TemplateFile '.\02-general.bicep' `
  -TemplateParameterFile .\02-general.bicepparam `
  -verbose





