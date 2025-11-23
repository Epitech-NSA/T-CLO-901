# Explication : Architecture du projet

Cette page explique l'architecture globale du projet et comment les différents composants interagissent.

## Vue d'ensemble

Le projet déploie une application Laravel sur Azure en utilisant deux architectures différentes : IaaS et PaaS. L'application est containerisée avec Docker et utilise une base de données MySQL.

## Architecture IaaS

```
┌─────────────────────────────────────────────────────────┐
│                    Azure Cloud                          │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │         Resource Group (rg-nan_1)                │  │
│  │                                                   │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │        Virtual Network (VNet)               │  │  │
│  │  │                                             │  │  │
│  │  │  ┌──────────────────────────────────────┐  │  │  │
│  │  │  │      Subnet (10.0.1.0/24)            │  │  │  │
│  │  │  │                                       │  │  │  │
│  │  │  │  ┌────────────────────────────────┐  │  │  │  │
│  │  │  │  │   Virtual Machine (Debian 12)   │  │  │  │  │
│  │  │  │  │                                 │  │  │  │  │
│  │  │  │  │  ┌──────────────────────────┐   │  │  │  │  │
│  │  │  │  │  │  Docker Container       │   │  │  │  │  │
│  │  │  │  │  │  (Laravel App)          │   │  │  │  │  │
│  │  │  │  │  └──────────────────────────┘   │  │  │  │  │
│  │  │  │  └────────────────────────────────┘  │  │  │  │
│  │  │  └──────────────────────────────────────┘  │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │  Azure Database for MySQL                  │  │  │
│  │  │  (Flexible Server)                         │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │  Network Security Group (NSG)              │  │  │
│  │  │  - Règle SSH (port 22)                     │  │  │
│  │  │  - Règle HTTP (port 80)                    │  │  │
│  │  │  - Règle HTTPS (port 443)                  │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │  Public IP Address                          │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Azure Container Registry (ACR)                  │  │
│  │  - image-iaas:latest                             │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
         ▲
         │
         │ (pull image)
         │
    ┌────┴────┐
    │  User   │
    │ (SSH)   │
    └─────────┘
```

### Composants IaaS

1. **Virtual Machine (VM)**
   - OS : Debian 12
   - Rôle : Héberge l'application dans un conteneur Docker
   - Accès : SSH pour administration

2. **Virtual Network (VNet)**
   - Réseau privé isolé
   - Sous-réseau pour la VM
   - Communication sécurisée avec la base de données

3. **Azure Database for MySQL**
   - Base de données managée
   - Accessible depuis la VM via le réseau privé
   - Authentification par identifiants

4. **Network Security Group (NSG)**
   - Règles de pare-feu pour le trafic entrant/sortant
   - Sécurise l'accès à la VM

5. **Public IP Address**
   - Adresse IP publique pour accéder à l'application
   - Associée à la VM

6. **Azure Container Registry (ACR)**
   - Stocke l'image Docker de l'application
   - La VM récupère l'image depuis ACR

### Flux de données IaaS

1. **Déploiement** :
   - Terraform crée l'infrastructure
   - Ansible configure la VM
   - Docker Compose démarre l'application

2. **Requête utilisateur** :
   - Utilisateur → Public IP → NSG → VM → Docker Container → Application Laravel

3. **Requête base de données** :
   - Application → MySQL (via réseau privé)

## Architecture PaaS

```
┌─────────────────────────────────────────────────────────┐
│                    Azure Cloud                          │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │         Resource Group (rg-nan_1)                │  │
│  │                                                   │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │        Virtual Network (VNet)               │  │  │
│  │  │                                             │  │  │
│  │  │  ┌──────────────────────────────────────┐  │  │  │
│  │  │  │  App Subnet (10.0.2.0/24)            │  │  │  │
│  │  │  │                                       │  │  │  │
│  │  │  │  ┌────────────────────────────────┐  │  │  │  │
│  │  │  │  │  App Service Plan (B1)          │  │  │  │  │
│  │  │  │  │                                 │  │  │  │  │
│  │  │  │  │  ┌──────────────────────────┐   │  │  │  │  │
│  │  │  │  │  │  Linux Web App            │   │  │  │  │  │
│  │  │  │  │  │  (Docker Container)       │   │  │  │  │  │
│  │  │  │  │  │  Laravel App              │   │  │  │  │  │
│  │  │  │  │  └──────────────────────────┘   │  │  │  │  │
│  │  │  │  └────────────────────────────────┘  │  │  │  │
│  │  │  └──────────────────────────────────────┘  │  │  │
│  │  │                                             │  │  │
│  │  │  ┌──────────────────────────────────────┐  │  │  │
│  │  │  │  MySQL Subnet (10.0.1.0/24)          │  │  │  │
│  │  │  │                                       │  │  │  │
│  │  │  │  ┌────────────────────────────────┐  │  │  │  │
│  │  │  │  │  Azure Database for MySQL      │  │  │  │  │
│  │  │  │  │  Flexible Server               │  │  │  │  │
│  │  │  │  └────────────────────────────────┘  │  │  │  │
│  │  │  └──────────────────────────────────────┘  │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  │  ┌────────────────────────────────────────────┐  │  │
│  │  │  Private Endpoint (App → DB)                │  │  │
│  │  └────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Azure Container Registry (ACR)                  │  │
│  │  - image-paas:latest                             │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
         ▲
         │
         │ (HTTPS)
         │
    ┌────┴────┐
    │  User   │
    │(Browser)│
    └─────────┘
```

### Composants PaaS

1. **App Service Plan**
   - Plan de service définit les ressources disponibles
   - Niveau : B1 (Basic)
   - Détermine le coût et les performances

2. **Linux Web App**
   - Application web managée
   - Exécute le conteneur Docker
   - Gestion automatique du scaling, des mises à jour, etc.

3. **Virtual Network (VNet)**
   - Réseau privé avec deux sous-réseaux :
     - App Subnet : pour l'App Service
     - MySQL Subnet : pour la base de données
   - Communication privée entre les composants

4. **Azure Database for MySQL Flexible Server**
   - Base de données managée
   - Accessible via réseau privé uniquement
   - Haute disponibilité et backups automatiques

5. **Private Endpoint**
   - Connexion privée entre App Service et MySQL
   - Trafic ne sort pas du réseau Azure

6. **Azure Container Registry (ACR)**
   - Stocke l'image Docker de l'application
   - L'App Service récupère l'image depuis ACR

### Flux de données PaaS

1. **Déploiement** :
   - Terraform crée toute l'infrastructure
   - App Service récupère l'image Docker depuis ACR
   - Application démarre automatiquement

2. **Requête utilisateur** :
   - Utilisateur → HTTPS → App Service → Docker Container → Application Laravel

3. **Requête base de données** :
   - Application → Private Endpoint → MySQL (via réseau privé)

## Comparaison des architectures

### Points communs

- ✅ Utilisation de Docker pour containeriser l'application
- ✅ Base de données Azure Database for MySQL
- ✅ Stockage des images dans Azure Container Registry
- ✅ Réseau virtuel pour isoler les ressources
- ✅ Infrastructure as Code avec Terraform

### Différences principales

| Aspect | IaaS | PaaS |
|--------|------|------|
| **Hébergement application** | VM avec Docker | App Service (managé) |
| **Configuration** | Ansible requis | Automatique |
| **Sous-réseaux** | 1 (VM) | 2 (App + DB) |
| **Accès** | Public IP + SSH | HTTPS uniquement |
| **Scaling** | Manuel | Automatique (selon plan) |
| **Maintenance OS** | À votre charge | Géré par Azure |

## Sécurité

### IaaS

- **NSG** : Règles de pare-feu pour contrôler le trafic
- **SSH** : Accès sécurisé pour l'administration
- **Réseau privé** : Communication sécurisée avec la base de données
- **Network Security Group (NSG)** : Règles de pare-feu configurées dans Terraform (ports 22, 80, 443)

### PaaS

- **HTTPS uniquement** : Communication chiffrée par défaut
- **Private Endpoint** : Connexion privée à la base de données
- **Isolation réseau** : Sous-réseaux séparés pour App et DB
- **Managed Identity** : Authentification sécurisée sans mots de passe

## Scalabilité

### IaaS

- Scaling manuel : Créer des VMs supplémentaires
- Load balancer : Nécessite configuration supplémentaire
- Temps de scaling : Plus long (création de VMs)

### PaaS

- Scaling automatique : Selon le plan App Service
- Load balancer : Intégré et automatique
- Temps de scaling : Plus rapide (instances managées)

## Monitoring

### IaaS

- Métriques VM : Via Azure Monitor
- Logs application : À configurer manuellement
- Monitoring infrastructure : À votre charge

### PaaS

- Métriques App Service : Intégrées dans Azure Portal
- Logs application : Streaming de logs intégré
- Monitoring infrastructure : Géré par Azure

