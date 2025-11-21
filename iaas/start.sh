#!/bin/bash
set -e
set -o pipefail

cd terraform
echo "Initialisation de Terraform..."
terraform init -reconfigure
echo "Application de la configuration Terraform..."
terraform apply -var-file="secret.tfvars" -auto-approve

ACR_PASSWORD=$(terraform output -raw acr_password)

cd ../ansible
echo "Ansible"
ansible-playbook playbooks/init_terra_cloud.yml --limit terra_cloud_app --extra-vars "acr_password=$ACR_PASSWORD"