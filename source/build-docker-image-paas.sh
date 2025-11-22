#!/bin/bash
set -e
set -o pipefail

# ---------- CONFIGURATION ----------
ACR_NAME="tcdevacrfrc01"                # Nom du registre (sans .azurecr.io)
IMAGE_NAME="image-paas"                 # Nom de l'image locale
IMAGE_TAG="latest"                      # Tag de l'image
LOCATION="francecentral"                # Région Azure
# ------------------------------------

cd sample-app-master

echo "Connexion à Azure..."
az login

echo "Récupération du login serveur..."
LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer -o tsv)

echo "Connexion au registre ACR..."
az acr login --name $ACR_NAME

echo "Build de l'image locale..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

echo "Tag de l'image locale..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

echo "Envoi de l’image vers Azure Container Registry..."
docker push ${LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

echo "Vérification du dépôt..."
az acr repository list --name $ACR_NAME -o table

echo "Image poussée avec succès dans $LOGIN_SERVER"

