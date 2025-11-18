#!/bin/bash

# ---------- CONFIGURATION ----------
ACR_NAME="monregistre"                  # Nom du registre (sans .azurecr.io)
IMAGE_NAME="monapp"                     # Nom de ton image locale
IMAGE_TAG="latest"                      # Tag de ton image
LOCATION="francecentral"                # Région Azure (si création ACR)
CREATE_ACR=true                         # Mettre à false si l'ACR existe déjà
# ------------------------------------

echo "🔐 Connexion à Azure..."
az login

if [ "$CREATE_ACR" = true ]; then
    echo "📦 Création du registre Azure Container Registry..."
    az acr create --resource-group $ACR_NAME-rg --name $ACR_NAME \
        --sku Basic --location $LOCATION --admin-enabled true

    echo "📁 Création du resource-group..."
    az group create --name $ACR_NAME-rg --location $LOCATION
fi

echo "🔍 Récupération du login serveur..."
LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer -o tsv)

echo "🔐 Connexion au registre ACR..."
az acr login --name $ACR_NAME

echo "🏷️ Tag de l'image locale..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

echo "🚀 Envoi de l’image vers Azure Container Registry..."
docker push ${LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

echo "✅ Vérification du dépôt..."
az acr repository list --name $ACR_NAME -o table

echo "🎉 Image poussée avec succès dans $LOGIN_SERVER"

