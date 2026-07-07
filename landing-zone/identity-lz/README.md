# Identity Landing Zone - Orchestrateur d'identités et RBAC

> **Version** : 1.0.0  
> **Région supportée** : `canadacentral` (`cace`), `canadaeast` (`caea`)  
> **Mainteneur** : Angeles Banaka  
> **Dernière mise à jour** : Juillet 2026
----

## Contenu du dossier

Ce dossier contient l’orchestrateur Bicep de la landing zone d’identité ainsi que les scripts d’automatisation associés à la création des objets Entra ID.

```text
identity-lz/
├── identity.bicep
├── identity.bicepparam
├── README.md
└── scripts/
    ├── configure_conditional_access_script.ps1
    ├── create_entra_groups_script.sh
    ├── create_service_principals_script.sh
    └── entra-groups.json
```

### Fichiers présents

- identity.bicep : template principal au scope subscription pour créer les managed identities et les affectations RBAC.
- identity.bicepparam : fichier de paramètres d’exemple avec les IDs de groupes Entra et de subscriptions.
- scripts/create_entra_groups_script.sh : création des groupes Entra ID.
- scripts/create_service_principals_script.sh : création des service principals.
- scripts/configure_conditional_access_script.ps1 : configuration des politiques Conditional Access.
- scripts/entra-groups.json : référentiel de groupes Entra ID utilisé par les scripts.

## Ce que déploie l’orchestrateur

Le template principal déploie :

- plusieurs Managed Identities User-Assigned
- des affectations RBAC au niveau subscription pour les groupes Entra ID
- les tags de conformité et d’exploitation applicables aux ressources d’identité

## Déploiement

Le flux recommandé est le suivant :

1. créer les groupes Entra ID avec le script shell
2. créer les Service Principals associés
3. appliquer la configuration Conditional Access avec PowerShell
4. déployer l’orchestrateur Bicep avec Azure CLI

```bash
# Exemple de déploiement
az deployment sub create \
  --name identity-lz-deploy \
  --location canadaeast \
  --template-file landing-zone/identity-lz/identity.bicep \
  --parameters landing-zone/identity-lz/identity.bicepparam
```

## Prérequis

Avant le déploiement, vérifier les points suivants :

- le resource group d’identité existe déjà
- les IDs de groupes Entra sont disponibles
- les subscriptions cibles sont connues et accessibles
- le principal de déploiement dispose des permissions RBAC nécessaires

## Notes de conception

- Les objets Entra ID sont créés hors du scope ARM/Bicep.
- L’orchestrateur Bicep se concentre sur les ressources Azure liées à l’identité et à la sécurité.
- La logique RBAC est centralisée dans le template principal et les modules partagés sous ../../modules/authorization.

## Ressources utiles

- Azure RBAC built-in roles
- Managed identities for Azure resources
- Microsoft Entra Conditional Access
