# Platform Landing Zone - Orchestrateur de la gouvernance et de l’observabilité

> **Version** : 1.0.0  
> **Région supportée** : `canadacentral` (`cace`), `canadaeast` (`caea`)  
> **Mainteneur** : Angeles Banaka  
> **Dernière mise à jour** : Juillet 2026
----

Ce dossier contient l’orchestrateur principal de la Platform Landing Zone ainsi que le fichier de paramètres associé.

## Structure du dossier

```text
platform-lz/
├── platform.bicep
├── platform.bicepparam
└── README.md
```

## Fichiers présents

- platform.bicep : template principal de la landing zone au scope managementGroup. Il définit la hiérarchie des management groups, les politiques d’initiative et les affectations associées.
- platform.bicepparam : fichier de paramètres d’exemple pour configurer l’organisation, l’environnement, la région et l’ID de la subscription de gestion.
- README.md : documentation du dossier.

## Objectif

La Platform Landing Zone sert de fondation de gouvernance et d’observabilité pour les autres landing zones du dépôt. Elle est conçue pour créer les structures de base nécessaires à la supervision et à la conformité Azure.

## Déploiement

Le template est déployé au scope managementGroup. Un exemple de commande Azure CLI est le suivant :

```bash
az deployment mg create \
  --name platform-lz-deploy \
  --management-group acmy-root \
  --location canadaeast \
  --template-file landing-zone/platform-lz/platform.bicep \
  --parameters landing-zone/platform-lz/platform.bicepparam
```

## Notes de conception

- Le template principal référence des modules partagés situés dans le dossier modules du dépôt.
- Le fichier de paramètres fournit une base de configuration adaptée à un environnement de sandbox.
- Les valeurs sont à adapter selon l’organisation et l’environnement cible.
