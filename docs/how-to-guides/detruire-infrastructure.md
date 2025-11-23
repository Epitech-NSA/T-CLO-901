# Guide : Détruire l'infrastructure

Ce guide vous explique comment détruire proprement l'infrastructure déployée pour éviter des coûts inutiles.

## ⚠️ Attention

La destruction de l'infrastructure est **irréversible**. Toutes les données stockées dans les ressources seront **perdues définitivement**, y compris :
- Les données de la base de données
- Les fichiers stockés sur la VM (IaaS)
- Les logs et métriques

Assurez-vous d'avoir sauvegardé toutes les données importantes avant de procéder.

## Destruction IaaS

### Méthode 1 : Utiliser le script fourni

Le projet fournit un script pour détruire l'infrastructure IaaS :

```bash
cd iaas
./stop.sh
```

Ce script :
1. Se place dans le dossier `terraform/`
2. Exécute `terraform destroy` avec le fichier de variables approprié
3. Supprime toutes les ressources créées par Terraform

### Méthode 2 : Destruction manuelle

Si vous préférez faire les étapes manuellement :

```bash
cd iaas/terraform
terraform destroy -var-file="secret.tfvars"
```

Terraform vous demandera confirmation avant de détruire les ressources. Tapez `yes` pour confirmer.

### Destruction automatique (sans confirmation)

Si vous voulez éviter la confirmation interactive :

```bash
cd iaas/terraform
terraform destroy -var-file="secret.tfvars" -auto-approve
```

## Destruction PaaS

### Méthode 1 : Utiliser le script fourni

Le projet fournit un script pour détruire l'infrastructure PaaS :

```bash
cd paas
./stop.sh
```

Ce script :
1. Se place dans le dossier `terraform/`
2. Exécute `terraform destroy` avec le fichier de variables approprié
3. Supprime toutes les ressources créées par Terraform

### Méthode 2 : Destruction manuelle

Si vous préférez faire les étapes manuellement :

```bash
cd paas/terraform
terraform destroy -var-file="terraform.tfvars"
```

Terraform vous demandera confirmation avant de détruire les ressources. Tapez `yes` pour confirmer.

### Destruction automatique (sans confirmation)

Si vous voulez éviter la confirmation interactive :

```bash
cd paas/terraform
terraform destroy -var-file="terraform.tfvars" -auto-approve
```

## Ce qui est détruit

### IaaS

Lors de la destruction, les ressources suivantes sont supprimées :
- La machine virtuelle (VM)
- Le disque de la VM
- L'adresse IP publique
- L'interface réseau
- La base de données Azure Database for MySQL
- Les règles de sécurité réseau (NSG)
- Le sous-réseau (si créé par Terraform)
- Le réseau virtuel (si créé par Terraform)

**Note** : Le groupe de ressources et le compte de stockage du backend Terraform ne sont généralement **pas** supprimés, car ils peuvent être partagés avec d'autres projets.

### PaaS

Lors de la destruction, les ressources suivantes sont supprimées :
- L'application web (App Service)
- Le plan App Service (App Service Plan)
- La base de données Azure Database for MySQL Flexible Server
- Les règles de sécurité réseau
- Les sous-réseaux (si créés par Terraform)
- Le réseau virtuel (si créé par Terraform)

**Note** : Le groupe de ressources et le compte de stockage du backend Terraform ne sont généralement **pas** supprimés.

## Vérification

### Vérifier que tout est détruit

Après la destruction, vérifiez dans le portail Azure que les ressources ont bien été supprimées :

1. Allez sur [portal.azure.com](https://portal.azure.com)
2. Recherchez votre groupe de ressources
3. Vérifiez que les ressources listées ci-dessus ne sont plus présentes

### Vérifier l'état Terraform

```bash
cd iaas/terraform  # ou paas/terraform
terraform show
```

Si tout est détruit, Terraform devrait indiquer qu'il n'y a plus de ressources.

## Problèmes courants

### Erreur : "resource is locked"

Parfois, une ressource peut être verrouillée (par exemple, une opération en cours). Dans ce cas :

1. Attendez quelques minutes
2. Réessayez la destruction
3. Si le problème persiste, allez dans le portail Azure et supprimez manuellement la ressource verrouillée

### Erreur : "resource group not found"

Si le groupe de ressources n'existe pas, c'est normal si vous l'avez déjà supprimé. La destruction peut échouer mais c'est sans conséquence.

### Certaines ressources ne sont pas supprimées

Si certaines ressources ne sont pas supprimées automatiquement :

1. Vérifiez les dépendances dans le portail Azure
2. Supprimez-les manuellement si nécessaire
3. Vérifiez que vous utilisez le bon fichier de variables

### État Terraform désynchronisé

Si l'état Terraform est désynchronisé avec Azure :

```bash
terraform refresh -var-file="secret.tfvars"  # ou terraform.tfvars
terraform destroy -var-file="secret.tfvars"   # ou terraform.tfvars
```

## Coûts

Après la destruction, vous ne devriez plus être facturé pour :
- Les ressources supprimées
- Les ressources de calcul (VM, App Service)
- Les bases de données

**Note** : Vous pouvez toujours être facturé pour :
- Le stockage du backend Terraform (généralement très faible)
- Les ressources partagées non supprimées (groupe de ressources vide, etc.)

## Bonnes pratiques

### Sauvegardes avant destruction

Avant de détruire, assurez-vous d'avoir :
- Exporté les données de la base de données si nécessaire
- Sauvegardé les fichiers importants de la VM (IaaS)
- Documenté la configuration si vous devez la recréer

### Destruction sélective

Si vous voulez détruire seulement certaines ressources :

```bash
terraform destroy -target=azurerm_virtual_machine.example -var-file="secret.tfvars"
```

### Plan de destruction

Pour voir ce qui sera détruit sans le faire :

```bash
terraform plan -destroy -var-file="secret.tfvars"  # ou terraform.tfvars
```

