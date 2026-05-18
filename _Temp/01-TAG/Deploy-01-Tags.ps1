# Connection dans le tenat SolulanLab02
Connect-AzAccount -Subscription '4cfddcec-1252-4a45-a98b-4a7dda675943'


    # déploie au niveau du Management Group "Tenant Root Group"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
New-AzManagementGroupDeployment `
  -ManagementGroupId 'DemoMGPBLab02' `
  -location "Canada Central" `
  -Name deploy_tagpolicies_$Timestamp `
  -TemplateFile '.\01-Tag.bicep' `
  -TemplateParameterFile '.\01-Tag.bicepparam' `
  -verbose



$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
New-AzManagementGroupDeployment `
  -ManagementGroupId 'DemoMGPBLab02' `
  -location "Canada Central" `
  -Name deploy_tagpolicies_$Timestamp `
  -TemplateFile '.\01-Tag.bicep' `
  -TemplateParameterFile '.\01-TagTest.bicepparam' `
  -verbose

