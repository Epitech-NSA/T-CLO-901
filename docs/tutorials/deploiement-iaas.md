# Tutoriel : Déploiement IaaS

Ce tutoriel vous guide pas à pas pour déployer l'application sur Azure en utilisant l'approche IaaS (Infrastructure as a Service) avec Terraform et Ansible.

## Objectif

À la fin de ce tutoriel, vous aurez :
- Créé l'infrastructure Azure (réseau, VM, base de données)
- Configuré la machine virtuelle avec Ansible
- Déployé l'application Laravel dans un conteneur Docker

## Étape 1 : Préparation

### 1.1 Vérifier les prérequis

Assurez-vous d'avoir installé :
- Terraform CLI
- Azure CLI
- Ansible
- Docker

Vérifiez les installations :
```bash
terraform --version
az --version
ansible --version
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

Construisez et poussez l'image pour IaaS :
```bash
./build-docker-image-iaas.sh
```

**Note** : Vous devrez peut-être modifier le script pour ajuster le nom du registre ACR (`ACR_NAME`).

## Étape 2 : Configuration

### 2.1 Configurer les variables Terraform

Copiez le fichier d'exemple des variables secrètes :
```bash
cd iaas/terraform
cp secret.tfvars.example secret.tfvars
```

Éditez `secret.tfvars` avec vos valeurs :
```hcl
rg_name = "rg-nan_1"
rg_location = "francecentral"
acr_name = "tcdevacrfrc01"

database_login = "votre_identifiant_db"
database_password = "votre_mot_de_passe_securise"
```

**Important** : Ne commitez jamais `secret.tfvars` dans le dépôt Git !

### 2.2 Configurer la clé SSH

Avant de lancer le déploiement, vous devez ajouter votre clé SSH publique dans le dossier `vm/` pour permettre l'accès à la machine virtuelle.

Copiez votre clé SSH publique dans le fichier requis :

```bash
# Depuis la racine du projet
cp ~/.ssh/id_rsa.pub iaas/terraform/vm/id_rsa.pub
```

**Note** : Si vous n'avez pas de clé SSH, vous pouvez en générer une avec :
```bash
ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"
```

**Important** : Cette clé SSH sera utilisée par Terraform pour configurer l'accès à la VM et par Ansible pour se connecter à la machine.

### 2.3 Configurer Ansible

Vérifiez la configuration Ansible dans `iaas/ansible/ansible.cfg`.

Copiez le fichier d'exemple de l'inventaire :
```bash
cd iaas/ansible
cp inventories/hosts.ini.example inventories/hosts.ini
```

L'inventaire sera automatiquement mis à jour par Terraform avec l'adresse IP de la VM créée.

## Étape 3 : Déploiement

### 3.1 Vérifier la configuration

Avant de lancer le déploiement, assurez-vous d'avoir :
- ✅ Configuré `secret.tfvars` avec vos valeurs
- ✅ Ajouté votre clé SSH dans `iaas/terraform/vm/id_rsa.pub`
- ✅ Construit et poussé l'image Docker vers ACR

### 3.2 Lancer le déploiement

Depuis la racine du projet, exécutez le script de démarrage :
```bash
cd iaas
./start.sh
```

Ce script effectue automatiquement :
1. L'initialisation de Terraform
2. La création de l'infrastructure (réseau, VM, base de données)
3. La récupération des informations nécessaires (ACR, base de données)
4. L'exécution du playbook Ansible pour configurer la VM

### 3.2 Comprendre ce qui se passe

Le script `start.sh` :
- Initialise Terraform dans le dossier `terraform/`
- Applique la configuration Terraform qui crée :
  - Un réseau virtuel (VNet) et un sous-réseau
  - Un Network Security Group (NSG) avec règles pour SSH, HTTP et HTTPS
  - Une machine virtuelle Linux
  - Une base de données Azure Database for MySQL
- Récupère les outputs Terraform (mots de passe, adresses, etc.)
- Exécute le playbook Ansible qui :
  - Configure SSH
  - Installe Docker
  - Démarre l'application avec Docker Compose

### 3.3 Vérifier le déploiement

Une fois le déploiement terminé, vous pouvez :

1. Vérifier l'état Terraform :
```bash
cd iaas/terraform
terraform output
```

2. Vérifier que la VM est accessible :
```bash
cd iaas/ansible
ansible all -i inventories/hosts.ini -m ping
```

3. Accéder à l'application via l'adresse IP publique de la VM (visible dans les outputs Terraform)

## Étape 4 : Vérification

### 4.1 Tester l'application

Récupérez l'adresse IP publique de la VM :
```bash
cd iaas/terraform
terraform output -raw vm_public_ip
```

Ouvrez votre navigateur et accédez à `http://<IP_PUBLIQUE>`.

### 4.2 Vérifier les logs

Si vous avez besoin de vérifier les logs de l'application, connectez-vous à la VM via SSH :
```bash
ssh ansible@<IP_PUBLIQUE>
```

Puis vérifiez les conteneurs Docker :
```bash
docker ps
docker logs <nom_du_conteneur>
```

## Prochaines étapes

- Consultez le [schéma de déploiement détaillé](../../iaas/deploiement-schema.md) pour comprendre le workflow complet
- Consultez le [guide pratique pour détruire l'infrastructure](../how-to-guides/detruire-infrastructure.md)
- Explorez la [référence des variables Terraform](../reference/variables-terraform.md)
- Découvrez les [différences entre IaaS et PaaS](../explanations/iaas-vs-paas.md)

## Dépannage

### Erreur de connexion Ansible

Si Ansible ne peut pas se connecter à la VM :
- Vérifiez que la clé SSH publique est correctement configurée
- Vérifiez les règles de sécurité réseau dans Azure
- Attendez quelques minutes après la création de la VM pour qu'elle soit complètement initialisée

### Erreur de pull Docker

Si l'application ne peut pas récupérer l'image Docker :
- Vérifiez que l'image a bien été poussée dans ACR
- Vérifiez que les identifiants ACR sont corrects dans Ansible
- Vérifiez que la VM a accès à ACR (règles réseau)

### Erreur de connexion à la base de données

Si l'application ne peut pas se connecter à la base de données :
- Vérifiez que les règles de pare-feu de la base de données autorisent la connexion depuis la VM
- Vérifiez les identifiants de la base de données dans les variables Ansible

