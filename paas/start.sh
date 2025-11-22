#!/bin/bash
set -e
set -o pipefail

cd terraform
echo "Initialisation de Terraform..."
terraform init -reconfigure
echo "Application de la configuration Terraform..."
terraform apply -var-file="terraform.tfvars" -auto-approve