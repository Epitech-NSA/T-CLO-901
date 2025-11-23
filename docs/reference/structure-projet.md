# Référence : Structure du projet

Cette page documente la structure complète du projet T-CLO-901.

## Structure générale

```
T-CLO-901/
├── docs/                    # Documentation (cette documentation)
├── iaas/                    # Déploiement IaaS
│   ├── ansible/            # Configuration Ansible
│   ├── terraform/          # Infrastructure Terraform
│   ├── start.sh            # Script de démarrage
│   └── stop.sh             # Script d'arrêt
├── paas/                    # Déploiement PaaS
│   ├── terraform/          # Infrastructure Terraform
│   ├── start.sh            # Script de démarrage
│   └── stop.sh             # Script d'arrêt
├── source/                  # Code source de l'application
│   ├── sample-app-master/  # Application Laravel
│   └── build-docker-*.sh   # Scripts de build Docker
└── README.md                # README principal
```

## Dossier `iaas/`

### `iaas/terraform/`

Infrastructure Terraform pour l'approche IaaS.

```
terraform/
├── bootstrap/              # Configuration bootstrap (backend, RG)
│   ├── main.tf
│   └── variables.tf
├── network/                # Réseau virtuel et sous-réseaux
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── db/                     # Base de données MySQL
│   ├── main.tf
│   └── outputs.tf
├── vm/                     # Machine virtuelle
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── id_rsa.pub          # Clé SSH publique
├── main.tf                 # Fichier principal (modules)
├── variables.tf            # Variables principales
├── outputs.tf              # Outputs principaux
├── secret.tfvars          # Variables secrètes (non versionné)
└── secret.tfvars.example  # Exemple de variables
```

**Modules Terraform :**
- `bootstrap` : Configure le backend Terraform et le groupe de ressources
- `network` : Crée le réseau virtuel, le sous-réseau et le Network Security Group (NSG)
- `db` : Crée la base de données Azure Database for MySQL
- `vm` : Crée la machine virtuelle Linux

### `iaas/ansible/`

Configuration Ansible pour configurer la VM.

```
ansible/
├── ansible.cfg             # Configuration Ansible
├── inventories/            # Inventaires
│   ├── hosts.ini          # Inventaire (mis à jour par Terraform)
│   └── hosts.ini.example  # Exemple d'inventaire
├── playbooks/             # Playbooks Ansible
│   └── init_terra_cloud.yml  # Playbook principal
├── roles/                 # Rôles Ansible
│   ├── install_docker/    # Installation de Docker
│   └── setup_ssh_key/    # Configuration SSH
└── files/                 # Fichiers à copier
    └── docker-compose.yaml # Configuration Docker Compose
```

**Rôles Ansible :**
- `install_docker` : Installe Docker et Docker Compose sur la VM
- `setup_ssh_key` : Configure l'accès SSH


**Playbook principal :**
- `init_terra_cloud.yml` : Orchestre l'exécution des rôles et démarre l'application

## Dossier `paas/`

### `paas/terraform/`

Infrastructure Terraform pour l'approche PaaS.

```
terraform/
├── bootstrap/              # Configuration bootstrap (backend, RG)
│   ├── main.tf
│   └── variables.tf
├── network/                # Réseau virtuel et sous-réseaux
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── db/                     # Base de données MySQL Flexible Server
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── app/                    # App Service (application web)
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── main.tf                 # Fichier principal (modules)
├── variables.tf            # Variables principales
├── outputs.tf              # Outputs principaux
├── terraform.tfvars       # Variables (peut contenir des secrets)
└── terraform.tfvars.example  # Exemple de variables
```

**Modules Terraform :**
- `bootstrap` : Configure le backend Terraform et le groupe de ressources
- `network` : Crée le réseau virtuel et les sous-réseaux (app et db)
- `db` : Crée la base de données Azure Database for MySQL Flexible Server
- `app` : Crée le plan App Service et l'application web Linux

## Dossier `source/`

### `source/sample-app-master/`

Application Laravel source.

```
sample-app-master/
├── app/                    # Code de l'application
├── config/                 # Configuration Laravel
├── database/               # Migrations et seeders
├── public/                 # Fichiers publics
├── routes/                 # Routes de l'application
├── Dockerfile              # Image Docker
├── docker-compose.yaml     # Docker Compose (développement local)
└── entrypoint.sh           # Script d'entrée du conteneur
```

### Scripts de build

- `build-docker-image-iaas.sh` : Construit et pousse l'image Docker pour IaaS
- `build-docker-image-paas.sh` : Construit et pousse l'image Docker pour PaaS

## Scripts de déploiement

### `iaas/start.sh`

Script de démarrage pour IaaS :
1. Initialise Terraform
2. Applique la configuration Terraform
3. Récupère les outputs Terraform
4. Exécute le playbook Ansible

### `iaas/stop.sh`

Script d'arrêt pour IaaS :
1. Détruit l'infrastructure Terraform

### `paas/start.sh`

Script de démarrage pour PaaS :
1. Initialise Terraform
2. Applique la configuration Terraform

### `paas/stop.sh`

Script d'arrêt pour PaaS :
1. Détruit l'infrastructure Terraform

## Fichiers de configuration

### Variables Terraform

- **IaaS** : `iaas/terraform/secret.tfvars` (non versionné)
- **PaaS** : `paas/terraform/terraform.tfvars` (peut contenir des secrets)

### Backend Terraform

Le backend Terraform est configuré pour stocker l'état dans Azure Storage :
- **Storage Account** : `sttcdevfrc01`
- **Container** : `tfstate`
- **Resource Group** : `rg-nan_1`

### Inventaire Ansible

- **Fichier** : `iaas/ansible/inventories/hosts.ini`
- **Mise à jour** : Automatiquement par Terraform avec l'IP de la VM

## Flux de déploiement

### IaaS

1. **Build Docker** : `source/build-docker-image-iaas.sh`
2. **Terraform** : Crée l'infrastructure (réseau, VM, DB)
3. **Ansible** : Configure la VM (Docker, pare-feu, SSH)
4. **Docker Compose** : Démarre l'application sur la VM

### PaaS

1. **Build Docker** : `source/build-docker-image-paas.sh`
2. **Terraform** : Crée l'infrastructure (réseau, App Service, DB)
3. **App Service** : Récupère l'image Docker et démarre l'application

## Fichiers à ne pas versionner

Ces fichiers contiennent des informations sensibles et ne doivent **jamais** être commités :

- `iaas/terraform/secret.tfvars`
- `paas/terraform/terraform.tfvars` (si contient des secrets)
- `iaas/terraform/terraform.tfstate*` (état Terraform)
- `paas/terraform/terraform.tfstate*` (état Terraform)
- `iaas/ansible/inventories/hosts.ini` (peut contenir des IPs)

Utilisez les fichiers `.example` comme modèles.

