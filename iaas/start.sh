#!/bin/bash
set -e
set -o pipefail

cd terraform
echo "Initialisation de Terraform..."
terraform init -reconfigure
echo "Application de la configuration Terraform..."
terraform apply -var-file="secret.tfvars" -auto-approve

echo "Récupération des outputs Terraform..."
ACR_PASSWORD=$(terraform output -raw acr_password)
DB_HOST=$(terraform output -raw db_host)
DB_DATABASE=$(terraform output -raw db_database)
DB_USERNAME=$(terraform output -raw db_username)
DB_PASSWORD=$(terraform output -raw db_password)

cd ../ansible
echo "Ansible"
ansible-playbook playbooks/init_terra_cloud.yml --limit terra_cloud_app \
  --extra-vars "acr_password=$ACR_PASSWORD" \
  --extra-vars "db_host=$DB_HOST" \
  --extra-vars "db_database=$DB_DATABASE" \
  --extra-vars "db_username=$DB_USERNAME" \
  --extra-vars "db_password=$DB_PASSWORD" \
  --extra-vars "app_key=base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4="