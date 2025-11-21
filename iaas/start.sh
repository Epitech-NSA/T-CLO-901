#!/bin/bash
set -e
set -o pipefail

cd terraform
echo "Initialisation de Terraform..."
terraform init -reconfigure
echo "Application de la configuration Terraform..."
terraform apply -var-file="secret.tfvars" -auto-approve

cd ../ansible
echo "Ansible"
ansible-playbook playbooks/init_terra_cloud.yml --limit terra_cloud_app