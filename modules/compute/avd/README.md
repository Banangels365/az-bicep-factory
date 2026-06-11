# Modules pour Azure Virtual Desktop (AVD)
Ce dossier contient des modules Bicep pour déployer et configurer des environnements Azure Virtual Desktop (AVD). Les modules inclus permettent de créer des Host Pools, des groupes d'applications, des applications, des plans de mise à l'échelle, et des espaces de travail AVD. Chaque module est conçu pour être flexible et réutilisable, avec des paramètres configurables pour répondre aux besoins spécifiques de chaque déploiement AVD.

## Modules disponibles
- `host_pool.bicep`: Module pour déployer un Host Pool AVD avec des configurations flexibles.
- `application_group.bicep`: Module pour déployer un groupe d'applications dans un Host Pool AVD.
- `application.bicep`: Module pour déployer une application dans un groupe d'applications AVD.
- `scaling_plan.bicep`: Module pour déployer un plan de mise à l'échelle pour un Host Pool AVD.
- `workspace.bicep`: Module pour déployer un espace de travail AVD et y associer des groupes d'applications.


## Description du module Host Pool
Le module `host_pool.bicep` permet de déployer un Host Pool AVD avec une configuration flexible, incluant des options pour le type de gestion, la durée de validité du token d'enregistrement, et les propriétés RDP personnalisées. Il retourne également des informations clés sur le Host Pool déployé, telles que le type de load balancing et le token d'enregistrement si applicable.

### Paramètres du module Host Pool

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Host Pool
```bicep
module hostPool './modules/avd/host_pool.bicep' = {
  name: 'hp-avd-prod-001'
  params: {
    name: 'hp-avd-prod-001'
    friendlyName: 'Host Pool de production'
    description: 'Host Pool pour les utilisateurs de production'
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    managementMode: 'AzureAD'
    registrationTokenValidityInMinutes: 1440
    customRdpProperties: 'audiocapturemode:i:1;audiomode:i:0;redirectprinters:i:1;redirectcomports:i:0;redirectsmartcards:i:1;redirectclipboard:i:1;redirectposdevices:i:0;autoreconnectionenabled:i:1;authenticationlevel:i:2;promptforcredentials:i:0;negotiateSecurityLayer:i:1;remoteapplicationmode:i:0;alternate shell:s:C:\\Windows\\System32\\mstsc.exe;shell working directory:s:C:\\Windows\\System32'
  }
}
```

## Description du module Application
Le module `application.bicep` permet de déployer une application dans un groupe d'applications AVD. Il prend en charge différents types d'applications, y compris les applications intégrées et les applications MSIX, et permet de configurer des propriétés telles que le nom convivial, la description, et les paramètres spécifiques à MSIX. Le module retourne des informations clés sur l'application déployée, telles que son Resource ID, son nom, et le nom du groupe d'applications parent.

### Paramètres du module Application

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Application
```bicep
module application './modules/avd/application.bicep' = {
  name: 'app-office365'
  params: {
    applicationGroupName: 'ag-avd-prod-001'
    name: 'Office365'
    friendlyName: 'Microsoft Office 365'
    applicationDescription: 'Suite bureautique Microsoft Office 365'
    applicationType: 'InBuilt'
    iconIndex: 0
  }
}
```

## Description du module Application Group
Le module `application_group.bicep` permet de déployer un groupe d'applications dans un Host Pool AVD. Il prend en charge différents types de groupes d'applications, y compris les groupes de bureaux et les groupes RemoteApp, et permet de configurer des propriétés telles que le nom convivial, la description, et les paramètres spécifiques à chaque type de groupe. Le module retourne des informations clés sur le groupe d'applications déployé, telles que son Resource ID, son nom, et une liste des noms des applications créées via le module enfant si le type de groupe est RemoteApp.

### Paramètres du module Application Group

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Application Group
```bicep
module applicationGroup './modules/avd/application_group.bicep' = {
  name: 'ag-avd-prod-001'
  params: {
    hostPoolName: 'hp-avd-prod-001'
    name: 'ag-avd-prod-001'
    friendlyName: 'Groupe d\'applications de production'
    description: 'Groupe d\'applications pour les utilisateurs de production'
    applicationGroupType: 'RemoteApp'
  }
}
```

## Description du module Scaling Plan
Le module `scaling_plan.bicep` permet de déployer un plan de mise à l'échelle pour un Host Pool AVD. Il prend en charge différents types de plan de mise à l'échelle, y compris les plans basés sur des règles et les plans basés sur des horaires, et permet de configurer des propriétés telles que le nom convivial, la description, et les paramètres spécifiques à chaque type de plan. Le module retourne des informations clés sur le plan de mise à l'échelle déployé, telles que son Resource ID, son nom, et une liste des règles de mise à l'échelle configurées si le type de plan est basé sur des règles.

### Paramètres du module Scaling Plan

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Scaling Plan
```bicep
module scalingPlan './modules/avd/scaling_plan.bicep' = {
  name: 'sp-avd-prod-001'
  params: {
    hostPoolName: 'hp-avd-prod-001'
    name: 'sp-avd-prod-001'
    friendlyName: 'Plan de mise à l\'échelle de production'
    description: 'Plan de mise à l\'échelle pour le Host Pool de production'
    scalingPlanType: 'ScheduleBased'
    scheduleBasedScalingPlan: {
      timeZone: 'Eastern Standard Time'
      schedules: [
        {
          name: 'weekday-morning'
          daysOfWeek: [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday'
          ]
          startTime: '08:00'
          endTime: '12:00'
          rampUpDuration: 'PT30M'
          rampDownDuration: 'PT30M'
          targetSessionHostCount: 5
        }
      ]
    }
  }
}
```

## Description du module Workspace
Le module `workspace.bicep` permet de déployer un espace de travail AVD et d'y associer un ou plusieurs groupes d'applications. Il prend en charge la configuration de propriétés telles que le nom convivial, la description, et les paramètres d'association des groupes d'applications. Le module retourne des informations clés sur l'espace de travail déployé, telles que son Resource ID, son nom, et une liste des noms des groupes d'applications associés.

### Paramètres du module Workspace

#### Inputs

#### Outputs

#### Ressources créées

### Exemple d'utilisation du module Workspace
```bicep
module workspace './modules/avd/workspace.bicep' = {
  name: 'ws-avd-prod-001'
  params: {
    name: 'ws-avd-prod-001'
    friendlyName: 'Espace de travail de production'
    description: 'Espace de travail pour les utilisateurs de production'
    applicationGroupNames: [
      'ag-avd-prod-001'
    ]
  }
}
```
