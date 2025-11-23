# Documentation T-CLO-901

Bienvenue dans la documentation du projet T-CLO-901. Ce projet compare deux approches de déploiement sur Azure : **IaaS** (Infrastructure as a Service) et **PaaS** (Platform as a Service).

## Vue d'ensemble

Ce projet permet de déployer une application Laravel sur Azure en utilisant deux méthodes différentes :

- **IaaS** : Utilisation de Terraform pour créer l'infrastructure (VM, réseau, base de données) et Ansible pour configurer la machine virtuelle
- **PaaS** : Utilisation de Terraform pour déployer directement sur des services managés Azure (App Service, Azure Database for MySQL)

## Structure de la documentation

Cette documentation suit la méthode Diataxis et est organisée en quatre types de documents :

### 📚 [Tutoriels](tutorials/)
Des guides pas à pas pour apprendre à déployer l'application :
- [Déploiement IaaS](tutorials/deploiement-iaas.md)
- [Déploiement PaaS](tutorials/deploiement-paas.md)

**Schémas de déploiement détaillés :**
- [Schéma IaaS](../iaas/deploiement-schema.md) - Workflow complet du déploiement IaaS
- [Schéma PaaS](../paas/deploiement-schema.md) - Workflow complet du déploiement PaaS

### 🔧 [Guides pratiques](how-to-guides/)
Des instructions pour accomplir des tâches spécifiques :
- [Construire et pousser l'image Docker](how-to-guides/build-push-docker.md)
- [Configurer les variables d'environnement](how-to-guides/configurer-variables.md)
- [Détruire l'infrastructure](how-to-guides/detruire-infrastructure.md)

### 📖 [Référence](reference/)
Documentation technique de référence :
- [Variables Terraform](reference/variables-terraform.md)
- [Structure du projet](reference/structure-projet.md)

### 💡 [Explications](explanations/)
Compréhension des concepts :
- [Différences IaaS vs PaaS](explanations/iaas-vs-paas.md)
- [Architecture du projet](explanations/architecture.md)

## Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- [Terraform](https://www.terraform.io/downloads) (version >= 1.1.0)
- [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) (pour IaaS uniquement)
- [Docker](https://www.docker.com/get-started) (pour construire les images)
- Un compte Azure avec les permissions appropriées

## Démarrage rapide

### IaaS
```bash
cd iaas
./start.sh
```

### PaaS
```bash
cd paas
./start.sh
```

Pour plus de détails, consultez les [tutoriels](tutorials/).

