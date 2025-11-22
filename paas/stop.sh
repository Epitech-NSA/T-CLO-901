set -e
set -o pipefail

cd terraform
echo "Destruction de la configuration Terraform..."
terraform destroy -var-file="terraform.tfvars" -auto-approve