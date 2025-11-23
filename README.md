# T-CLO-901

Projet de comparaison entre deux formats de déploiement sur Azure : **IaaS** (Terraform + Ansible) et **PaaS** (Terraform).

## 📚 Documentation

**👉 Consultez la [documentation complète](docs/index.md) pour des guides détaillés.**

La documentation suit la méthode Diataxis et inclut :
- **Tutoriels** : Guides pas à pas pour déployer en IaaS et PaaS
- **Guides pratiques** : Construire les images Docker, configurer les variables, détruire l'infrastructure
- **Référence** : Variables Terraform, structure du projet
- **Explications** : Différences IaaS vs PaaS, architecture du projet

## 🚀 Démarrage rapide

### Prérequis

- [Terraform](https://www.terraform.io/downloads) (>= 1.1.0)
- [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) (pour IaaS uniquement)
- [Docker](https://www.docker.com/get-started)
- Un compte Azure avec les permissions appropriées

### IaaS

```bash
# 1. Construire et pousser l'image Docker
cd source
./build-docker-image-iaas.sh

# 2. Configurer les variables
cd ../iaas/terraform
cp secret.tfvars.example secret.tfvars
# Éditer secret.tfvars avec vos valeurs

# 3. Déployer
cd ..
./start.sh
```

### PaaS

```bash
# 1. Construire et pousser l'image Docker
cd source
./build-docker-image-paas.sh

# 2. Configurer les variables
cd ../paas/terraform
cp terraform.tfvars.example terraform.tfvars
# Éditer terraform.tfvars avec vos valeurs

# 3. Déployer
cd ..
./start.sh
```

## 📖 Pour plus d'informations

Consultez la [documentation complète](docs/index.md) pour :
- Des tutoriels détaillés pas à pas
- Des guides pratiques pour les tâches courantes
- La référence technique complète
- Des explications sur les concepts et architectures