# Référence : Variables Terraform

Cette page documente toutes les variables Terraform utilisées dans le projet.

## Variables IaaS

### Variables requises

#### `rg_name`
- **Type** : `string`
- **Description** : Nom du groupe de ressources Azure
- **Exemple** : `"rg-nan_1"`

#### `rg_location`
- **Type** : `string`
- **Description** : Région Azure où déployer les ressources
- **Exemple** : `"francecentral"`, `"westeurope"`

#### `acr_name`
- **Type** : `string`
- **Description** : Nom de l'Azure Container Registry (sans le suffixe `.azurecr.io`)
- **Exemple** : `"tcdevacrfrc01"`

#### `database_login`
- **Type** : `string`
- **Description** : Identifiant administrateur de la base de données MySQL
- **Défaut** : `"identifiant"`
- **Exemple** : `"admin_user"`

#### `database_password`
- **Type** : `string`
- **Sensitive** : `true`
- **Description** : Mot de passe administrateur de la base de données MySQL
- **Exemple** : `"VotreMotDePasseSecurise123!"`

### Variables optionnelles

#### `rg_tags`
- **Type** : `map(string)`
- **Description** : Tags à appliquer au groupe de ressources
- **Défaut** :
  ```hcl
  {
    env            = "dev"
    owner          = "etu-epitech"
    project        = "TERRACLOUD"
    shutdownPolicy = "19:00-08:00"
    subscription   = "6b9318b1-2215-418a-b0fd-ba0832e9b333"
  }
  ```

#### `subnet`
- **Type** : `map(string)`
- **Description** : Configuration du sous-réseau pour la VM
- **Défaut** :
  ```hcl
  {
    name           = "tc-snet-iaas-frc-01"
    address_prefix = "10.0.1.0/24"
  }
  ```

## Variables PaaS

### Variables requises

#### `rg_name`
- **Type** : `string`
- **Description** : Nom du groupe de ressources Azure
- **Défaut** : `"rg-nan_1"`
- **Exemple** : `"rg-nan_1"`

#### `rg_location`
- **Type** : `string`
- **Description** : Région Azure où déployer les ressources
- **Défaut** : `"francecentral"`
- **Exemple** : `"francecentral"`, `"westeurope"`

#### `acr_name`
- **Type** : `string`
- **Description** : Nom de l'Azure Container Registry (sans le suffixe `.azurecr.io`)
- **Exemple** : `"tcdevacrfrc01"`

#### `database_login`
- **Type** : `string`
- **Description** : Identifiant administrateur de la base de données MySQL
- **Exemple** : `"admin_user"`

#### `database_password`
- **Type** : `string`
- **Description** : Mot de passe administrateur de la base de données MySQL
- **Exemple** : `"VotreMotDePasseSecurise123!"`

### Variables optionnelles

#### `rg_tags`
- **Type** : `map(string)`
- **Description** : Tags à appliquer au groupe de ressources
- **Défaut** :
  ```hcl
  {
    env            = "dev"
    owner          = "etu-epitech"
    project        = "TERRACLOUD"
    shutdownPolicy = "19:00-08:00"
    subscription   = "6b9318b1-2215-418a-b0fd-ba0832e9b333"
  }
  ```

#### `vnet`
- **Type** : `map(string)`
- **Description** : Configuration du réseau virtuel
- **Défaut** :
  ```hcl
  {
    name          = "tc-vnet-paas-frc-01"
    address_space = "10.0.0.0/16"
  }
  ```

#### `app_subnet`
- **Type** : `map(string)`
- **Description** : Configuration du sous-réseau pour l'App Service
- **Défaut** :
  ```hcl
  {
    name            = "tc-snet-paas-app-frc-01"
    address_prefixes = "10.0.2.0/24"
  }
  ```

#### `mysql_subnet`
- **Type** : `map(string)`
- **Description** : Configuration du sous-réseau pour la base de données MySQL
- **Défaut** :
  ```hcl
  {
    name            = "tc-snet-paas-db-frc-01"
    address_prefixes = "10.0.1.0/24"
  }
  ```

## Variables d'environnement de l'application

### IaaS (via Docker Compose)

Les variables suivantes sont configurées dans `iaas/ansible/files/docker-compose.yaml` :

- `DB_HOST` : Adresse FQDN de la base de données
- `DB_DATABASE` : Nom de la base de données
- `DB_USERNAME` : Identifiant de connexion à la base de données
- `DB_PASSWORD` : Mot de passe de connexion à la base de données
- `DB_PORT` : Port de la base de données (3306)
- `APP_KEY` : Clé d'application Laravel
- `APP_ENV` : Environnement de l'application (`production`, `development`)
- `APP_DEBUG` : Mode debug (`true` ou `false`)

### PaaS (via App Service Settings)

Les variables suivantes sont configurées dans `paas/terraform/app/main.tf` :

- `WEBSITES_PORT` : Port exposé par le conteneur (80)
- `DOCKER_ENABLE_CI` : Active le Continuous Integration pour Docker (`true`)
- `APP_DEBUG` : Mode debug (`false`)
- `APP_ENV` : Environnement (`production`)
- `APP_KEY` : Clé d'application Laravel
- `DB_CONNECTION` : Type de connexion (`mysql`)
- `DB_HOST` : Adresse FQDN de la base de données
- `DB_PORT` : Port de la base de données (3306)
- `DB_DATABASE` : Nom de la base de données
- `DB_USERNAME` : Identifiant de connexion
- `DB_PASSWORD` : Mot de passe de connexion

## Utilisation

### Définir des variables

#### Via fichier `.tfvars`

Créez un fichier `secret.tfvars` (IaaS) ou `terraform.tfvars` (PaaS) :

```hcl
rg_name = "rg-nan_1"
rg_location = "francecentral"
acr_name = "tcdevacrfrc01"
database_login = "admin"
database_password = "SecurePassword123!"
```

Puis utilisez-le :
```bash
terraform apply -var-file="secret.tfvars"
```

#### Via ligne de commande

```bash
terraform apply \
  -var="rg_name=rg-nan_1" \
  -var="rg_location=francecentral" \
  -var="database_password=SecurePassword123!"
```

#### Via variables d'environnement

Préfixez les variables avec `TF_VAR_` :

```bash
export TF_VAR_rg_name="rg-nan_1"
export TF_VAR_database_password="SecurePassword123!"
terraform apply
```

### Priorité des variables

Terraform utilise les variables dans cet ordre de priorité (du plus prioritaire au moins prioritaire) :

1. Variables définies via `-var` ou `-var-file` en ligne de commande
2. Variables définies dans un fichier `terraform.tfvars` (automatiquement chargé)
3. Variables définies dans un fichier `*.auto.tfvars` (automatiquement chargé)
4. Variables d'environnement `TF_VAR_*`
5. Valeurs par défaut dans `variables.tf`
6. Terraform demande une valeur si la variable est requise et n'a pas de valeur par défaut

## Bonnes pratiques

### Variables sensibles

Marquez les variables sensibles avec `sensitive = true` dans `variables.tf` :

```hcl
variable "database_password" {
  type      = string
  sensitive = true
}
```

Cela empêche Terraform d'afficher la valeur dans les logs.

### Validation

Ajoutez des validations pour les variables :

```hcl
variable "rg_location" {
  type        = string
  description = "Région Azure"
  
  validation {
    condition     = contains(["francecentral", "westeurope"], var.rg_location)
    error_message = "La région doit être francecentral ou westeurope."
  }
}
```

### Documentation

Documentez toujours vos variables :

```hcl
variable "rg_name" {
  type        = string
  description = "Nom du groupe de ressources Azure"
  default     = "rg-nan_1"
}
```

