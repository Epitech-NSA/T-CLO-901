# Guide : Construire et pousser l'image Docker

Ce guide vous explique comment construire et pousser l'image Docker de l'application vers Azure Container Registry (ACR).

## Prérequis

- Docker installé et fonctionnel
- Azure CLI installé et configuré
- Accès à un Azure Container Registry existant
- Permissions pour pousser des images dans ACR

## Méthode 1 : Utiliser les scripts fournis

### Pour IaaS

Le projet fournit un script automatique pour IaaS :

```bash
cd source
./build-docker-image-iaas.sh
```

### Pour PaaS

Le projet fournit un script automatique pour PaaS :

```bash
cd source
./build-docker-image-paas.sh
```

## Méthode 2 : Étapes manuelles

Si vous préférez faire les étapes manuellement ou si vous devez personnaliser le processus :

### 1. Se connecter à Azure

```bash
az login
```

### 2. Se connecter à ACR

Remplacez `tcdevacrfrc01` par le nom de votre registre :

```bash
az acr login --name tcdevacrfrc01
```

### 3. Récupérer l'URL du serveur de connexion

```bash
LOGIN_SERVER=$(az acr show --name tcdevacrfrc01 --query loginServer -o tsv)
echo $LOGIN_SERVER
```

### 4. Construire l'image localement

Pour IaaS :
```bash
cd source/sample-app-master
docker build -t image-iaas:latest .
```

Pour PaaS :
```bash
cd source/sample-app-master
docker build -t image-paas:latest .
```

### 5. Tagger l'image pour ACR

Pour IaaS :
```bash
docker tag image-iaas:latest ${LOGIN_SERVER}/image-iaas:latest
```

Pour PaaS :
```bash
docker tag image-paas:latest ${LOGIN_SERVER}/image-paas:latest
```

### 6. Pousser l'image vers ACR

Pour IaaS :
```bash
docker push ${LOGIN_SERVER}/image-iaas:latest
```

Pour PaaS :
```bash
docker push ${LOGIN_SERVER}/image-paas:latest
```

### 7. Vérifier que l'image a été poussée

```bash
az acr repository list --name tcdevacrfrc01 -o table
az acr repository show-tags --name tcdevacrfrc01 --repository image-iaas -o table
az acr repository show-tags --name tcdevacrfrc01 --repository image-paas -o table
```

## Personnalisation

### Changer le nom de l'image

Si vous voulez utiliser un nom d'image différent, modifiez les scripts ou les commandes ci-dessus en remplaçant `image-iaas` ou `image-paas` par votre nom.

**Important** : Si vous changez le nom de l'image, vous devrez également mettre à jour :
- Pour IaaS : le fichier `iaas/ansible/files/docker-compose.yaml`
- Pour PaaS : le fichier `paas/terraform/app/main.tf` (variable `docker_image_name`)

### Changer le tag

Par défaut, les scripts utilisent le tag `latest`. Pour utiliser un tag spécifique (par exemple, une version) :

```bash
docker tag image-iaas:latest ${LOGIN_SERVER}/image-iaas:v1.0.0
docker push ${LOGIN_SERVER}/image-iaas:v1.0.0
```

N'oubliez pas de mettre à jour la configuration Terraform/Ansible pour utiliser ce tag.

## Dépannage

### Erreur : "unauthorized: authentication required"

Cela signifie que vous n'êtes pas authentifié auprès d'ACR. Réessayez :
```bash
az acr login --name tcdevacrfrc01
```

### Erreur : "denied: requested access to the resource is denied"

Cela signifie que vous n'avez pas les permissions pour pousser dans ce registre. Vérifiez vos permissions Azure :
```bash
az acr show --name tcdevacrfrc01 --query permissions
```

### L'image est trop volumineuse

Si l'image est très volumineuse, considérez :
- Optimiser le Dockerfile (multi-stage builds, .dockerignore)
- Utiliser un registre plus proche géographiquement
- Vérifier votre connexion internet

### Vérifier la taille de l'image

```bash
docker images ${LOGIN_SERVER}/image-iaas:latest
```

