# Tutoriel : Déploiement PaaS

Ce tutoriel vous guide pas à pas pour déployer l'application sur Azure en utilisant l'approche PaaS (Platform as a Service) avec Terraform uniquement.

## Objectif

À la fin de ce tutoriel, vous aurez :
- Créé l'infrastructure Azure managée (App Service, base de données)
- Déployé l'application Laravel sur Azure App Service
- Configuré la connexion à la base de données

## Étape 1 : Préparation

### 1.1 Vérifier les prérequis

Assurez-vous d'avoir installé :
- Terraform CLI
- Azure CLI
- Docker

Vérifiez les installations :
```bash
terraform --version
az --version
docker --version
```

### 1.2 Se connecter à Azure

Connectez-vous à votre compte Azure :
```bash
az login
```

Vérifiez que vous êtes connecté au bon abonnement :
```bash
az account show
```

Si nécessaire, changez d'abonnement :
```bash
az account set --subscription "VOTRE_SUBSCRIPTION_ID"
```

### 1.3 Construire et pousser l'image Docker

Avant de déployer l'infrastructure, vous devez construire et pousser l'image Docker de l'application vers Azure Container Registry (ACR).

Allez dans le dossier source :
```bash
cd source
```

Construisez et poussez l'image pour PaaS :
```bash
./build-docker-image-paas.sh
```

**Note** : Vous devrez peut-être modifier le script pour ajuster le nom du registre ACR (`ACR_NAME`).

## Étape 2 : Configuration

### 2.1 Configurer les variables Terraform

Copiez le fichier d'exemple des variables :
```bash
cd paas/terraform
cp terraform.tfvars.example terraform.tfvars
```

Éditez `terraform.tfvars` avec vos valeurs :
```hcl
rg_name = "rg-nan_1"
rg_location = "francecentral"
database_login = "votre_identifiant_db"
database_password = "votre_mot_de_passe_securise"
acr_name = "tcdevacrfrc01"
```

**Important** : Ne commitez jamais `terraform.tfvars` dans le dépôt Git s'il contient des secrets !

### 2.2 Vérifier la configuration du backend

Le backend Terraform est configuré pour stocker l'état dans Azure Storage. Vérifiez que les valeurs dans `terraform/main.tf` correspondent à votre configuration :

```hcl
backend "azurerm" {
  resource_group_name  = "rg-nan_1"
  storage_account_name = "sttcdevfrc01"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
```

## Étape 3 : Déploiement

### 3.1 Lancer le déploiement

Depuis la racine du projet, exécutez le script de démarrage :
```bash
cd paas
./start.sh
```

Ce script effectue automatiquement :
1. L'initialisation de Terraform
2. La création de l'infrastructure (réseau, App Service, base de données)

### 3.2 Comprendre ce qui se passe

Le script `start.sh` :
- Initialise Terraform dans le dossier `terraform/`
- Applique la configuration Terraform qui crée :
  - Un réseau virtuel (VNet) et des sous-réseaux
  - Un plan App Service (App Service Plan)
  - Une application web Linux (Linux Web App) qui utilise votre image Docker
  - Une base de données Azure Database for MySQL Flexible Server
  - Les règles de sécurité réseau nécessaires
  - La configuration de l'application (variables d'environnement, connexion à la base de données)

### 3.3 Vérifier le déploiement

Une fois le déploiement terminé, vous pouvez :

1. Vérifier l'état Terraform :
```bash
cd paas/terraform
terraform output
```

2. Vérifier l'application dans le portail Azure :
   - Allez sur [portal.azure.com](https://portal.azure.com)
   - Recherchez votre App Service (nom : `tc-app-paas-frc-01` par défaut)
   - Vérifiez l'état et les logs

## Étape 4 : Vérification

### 4.1 Tester l'application

Récupérez l'URL de l'application :
```bash
cd paas/terraform
terraform output -raw app_url
```

Ou récupérez le nom de l'App Service et accédez à `https://<nom-app-service>.azurewebsites.net`

### 4.2 Vérifier les logs

Vous pouvez consulter les logs de l'application de plusieurs façons :

**Via Azure CLI :**
```bash
az webapp log tail --name tc-app-paas-frc-01 --resource-group rg-nan_1
```

**Via le portail Azure :**
1. Allez sur votre App Service
2. Dans le menu de gauche, cliquez sur "Journaux" (Log stream)
3. Activez le streaming de logs si nécessaire

### 4.3 Vérifier la configuration

Vérifiez les variables d'environnement de l'application :
```bash
az webapp config appsettings list --name tc-app-paas-frc-01 --resource-group rg-nan_1
```

## Prochaines étapes

- Consultez le [schéma de déploiement détaillé](../../paas/deploiement-schema.md) pour comprendre le workflow complet
- Consultez le [guide pratique pour détruire l'infrastructure](../how-to-guides/detruire-infrastructure.md)
- Explorez la [référence des variables Terraform](../reference/variables-terraform.md)
- Découvrez les [différences entre IaaS et PaaS](../explanations/iaas-vs-paas.md)

## Dépannage

### L'application ne démarre pas

Si l'application ne démarre pas :
- Vérifiez les logs de l'App Service (voir section 4.2)
- Vérifiez que l'image Docker existe dans ACR avec le bon tag
- Vérifiez que les identifiants ACR sont corrects
- Vérifiez que le port configuré dans `WEBSITES_PORT` correspond au port exposé par votre conteneur

### Erreur de connexion à la base de données

Si l'application ne peut pas se connecter à la base de données :
- Vérifiez que les règles de pare-feu de la base de données autorisent les connexions depuis Azure
- Vérifiez que les variables d'environnement de la base de données sont correctes
- Vérifiez que le sous-réseau de l'App Service peut accéder au sous-réseau de la base de données

### Erreur de pull Docker

Si l'App Service ne peut pas récupérer l'image Docker :
- Vérifiez que l'image a bien été poussée dans ACR
- Vérifiez que les identifiants ACR sont corrects dans la configuration App Service
- Vérifiez que l'App Service a accès à ACR (peut nécessiter une identité managée)

### L'application est lente

Si l'application est lente :
- Vérifiez le niveau de service (SKU) de votre App Service Plan (par défaut : B1, niveau de base)
- Considérez d'augmenter le niveau de service pour de meilleures performances
- Vérifiez les métriques dans le portail Azure

