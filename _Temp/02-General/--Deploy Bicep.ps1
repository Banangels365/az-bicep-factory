
Connect-AzAccount -Subscription 'f8d17dee-320f-4765-a0df-a0251ececb1a'

$Context = Get-AzSubscription -SubscriptionId "f8d17dee-320f-4765-a0df-a0251ececb1a"
Set-AzContext $context 
Get-AzResourceGroup  -Name 'rg-bicep02' 


#=========   02-General.bicep ============================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateFile '.\main.bicep' `
  -verbose 


  #=========   02-General.bicep ============================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
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
  -TemplateFile '.\02-General.bicep' `
  -TemplateParameterFile .\02-General.bicepparam `
  -verbose


    # déploie au niveau du Management Group "Tenant Root Group"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
New-AzManagementGroupDeployment `
  -ManagementGroupId 'managementgroupb' `
  -location "Canada Central" `
  -Name deploy_$Timestamp `
  -TemplateFile '.\main.bicep' `
  -TemplateParameterFile .\main.bicepparam `
  -verbose









#========02-General.bicep et Param================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateParameterFile '.\02-General.bicepparam' `
  -TemplateFile '.\02-General.bicep' `
  -verbose 

  #========03-network.bicep et Param================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateParameterFile '.\03-network.bicepparam' `
  -TemplateFile '.\03-network.bicep' `
  -verbose 

  #========04-keyVault.bicep et Param================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateParameterFile '.\04-keyVault.bicepparam' `
  -TemplateFile '.\04-keyVault.bicep' `
  -verbose 


#============================================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateFile '.\05-vm.bicep' `
  -verbose 


#===============05-VM.bicep et Param================= 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateParameterFile '.\05-vm.bicepparam' `
  -TemplateFile '.\05-VM.bicep' `
  -verbose 

#============================================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateFile '.\06-storageAccount.bicep' `
  -verbose 



  #============06-storageAccount.bicep et Param=============================== 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateParameterFile '.\06-storageAccount.bicepparam' `
  -TemplateFile '.\06-storageAccount.bicep' `
  -verbose 

  #============================================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateParameterFile '.\05-VM.bicepparam' `
  -TemplateFile '.\05-VM.bicep' `
  -verbose 





#============================================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateFile '.\03-network.bicep' `
  -TemplateParameterFile '.\03-network.bicepparam' `
  -verbose 

#============================================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateFile .\04-keyVault.bicep `
  -TemplateParameterFile .\04-keyVault.bicepparam `
  -verbose 

#============================================================ 
$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzTenantDeployment `
  -Location "eastus" `
    -Name deploy_$Timestamp `
    -TemplateFile "C:\_SolulanPolicies02\managementGroup\managementGroup.bicep" 
  


$timestamp = Get-Date -Format "yyyy-MM-dd_HH_mm"
# Lance le déploiement
New-AzsubscriptionDeployment `
  -location 'eastus' `
  -Name deploy_$Timestamp `
  -TemplateFile 'C:\_SolulanPolicies02\tempo\tempo.bicep' `
  -TemplateParameterFile 'C:\_SolulanPolicies02\tempo\tempo.bicepparam' `
  -verbose 
