# Guide : Configurer les variables d'environnement

Ce guide vous explique comment configurer les variables nécessaires pour le déploiement IaaS et PaaS.

## Variables communes

Les deux approches nécessitent certaines variables communes :

- `rg_name` : Nom du groupe de ressources Azure
- `rg_location` : Région Azure (ex: `francecentral`, `westeurope`)
- `acr_name` : Nom de l'Azure Container Registry
- `database_login` : Identifiant administrateur de la base de données
- `database_password` : Mot de passe administrateur de la base de données

## Configuration IaaS

### Fichier de variables

Le fichier de variables pour IaaS se trouve dans `iaas/terraform/secret.tfvars`.

### Créer le fichier

```bash
cd iaas/terraform
cp secret.tfvars.example secret.tfvars
```

### Variables requises

Éditez `secret.tfvars` :

```hcl
rg_name = "rg-nan_1"
rg_location = "francecentral"
acr_name = "tcdevacrfrc01"

database_login = "admin_user"
database_password = "VotreMotDePasseSecurise123!"
```

### Variables optionnelles

Vous pouvez également personnaliser le sous-réseau dans `variables.tf` ou créer un fichier de variables supplémentaire :

```hcl
subnet = {
  name           = "tc-snet-iaas-frc-01"
  address_prefix = "10.0.1.0/24"
}
```

### Sécurité

**⚠️ Important** : Le fichier `secret.tfvars` contient des informations sensibles. 

- Ne le commitez **jamais** dans Git
- Ajoutez-le au `.gitignore`
- Utilisez des mots de passe forts
- Considérez l'utilisation d'Azure Key Vault pour les secrets en production

## Configuration PaaS

### Fichier de variables

Le fichier de variables pour PaaS se trouve dans `paas/terraform/terraform.tfvars`.

### Créer le fichier

```bash
cd paas/terraform
cp terraform.tfvars.example terraform.tfvars
```

### Variables requises

Éditez `terraform.tfvars` :

```hcl
rg_name = "rg-nan_1"
rg_location = "francecentral"
database_login = "admin_user"
database_password = "VotreMotDePasseSecurise123!"
acr_name = "tcdevacrfrc01"
```

### Variables optionnelles

Vous pouvez personnaliser le réseau dans `variables.tf` :

```hcl
vnet = {
  name = "tc-vnet-paas-frc-01"
  address_space = "10.0.0.0/16"
}

app_subnet = {
  name = "tc-snet-paas-app-frc-01"
  address_prefixes = "10.0.2.0/24"
}

mysql_subnet = {
  name = "tc-snet-paas-db-frc-01"
  address_prefixes = "10.0.1.0/24"
}
```

## Variables d'environnement de l'application

### IaaS

Pour IaaS, les variables d'environnement sont configurées dans le fichier `docker-compose.yaml` utilisé par Ansible (`iaas/ansible/files/docker-compose.yaml`).

Les variables principales sont :
- `DB_HOST` : Adresse de la base de données
- `DB_DATABASE` : Nom de la base de données
- `DB_USERNAME` : Identifiant de connexion
- `DB_PASSWORD` : Mot de passe de connexion
- `APP_KEY` : Clé d'application Laravel

Ces variables sont automatiquement injectées par Ansible lors du déploiement.

### PaaS

Pour PaaS, les variables d'environnement sont configurées dans Terraform (`paas/terraform/app/main.tf`) dans la section `app_settings` :

```hcl
app_settings = {
  WEBSITES_PORT               = "80"
  DOCKER_ENABLE_CI            = "true"
  APP_DEBUG                   = "false"
  APP_ENV                     = "production"
  APP_KEY                     = "base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4="
  DB_CONNECTION               = "mysql"
  DB_HOST                     = var.db_fqdn
  DB_PORT                     = "3306"
  DB_DATABASE                 = var.db_name
  DB_USERNAME                 = var.db_administrator_login
  DB_PASSWORD                 = var.db_administrator_password
}
```

## Bonnes pratiques

### Mots de passe

- Utilisez des mots de passe forts (minimum 12 caractères, mélange de majuscules, minuscules, chiffres et symboles)
- Ne réutilisez pas les mêmes mots de passe pour différents environnements
- Changez les mots de passe régulièrement

### Gestion des secrets

Pour la production, considérez :
- **Azure Key Vault** : Stocker les secrets dans Key Vault et les récupérer via Terraform
- **Variables d'environnement système** : Utiliser des variables d'environnement au lieu de fichiers
- **Secrets managers** : Utiliser des outils comme HashiCorp Vault

### Exemple avec Azure Key Vault

```hcl
data "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  key_vault_id = azurerm_key_vault.example.id
}

variable "database_password" {
  type        = string
  default     = data.azurerm_key_vault_secret.db_password.value
  sensitive   = true
}
```

## Vérification

### Vérifier les variables Terraform

Pour voir les variables qui seront utilisées :

```bash
cd iaas/terraform  # ou paas/terraform
terraform plan -var-file="secret.tfvars"  # ou terraform.tfvars
```

### Vérifier les variables d'environnement (PaaS)

Pour voir les variables d'environnement configurées dans App Service :

```bash
az webapp config appsettings list \
  --name tc-app-paas-frc-01 \
  --resource-group rg-nan_1 \
  --output table
```

## Dépannage

### Erreur : "variable not set"

Vérifiez que toutes les variables requises sont définies dans votre fichier `.tfvars`.

### Erreur : "sensitive variable"

Les variables marquées comme `sensitive` dans Terraform ne seront pas affichées dans les logs. C'est normal et sécurisé.

### Variables non appliquées

Assurez-vous de spécifier le bon fichier de variables lors de l'exécution :
- IaaS : `terraform apply -var-file="secret.tfvars"`
- PaaS : `terraform apply -var-file="terraform.tfvars"`

