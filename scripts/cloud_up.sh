#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/../terraform"
ANSIBLE_DIR="$SCRIPT_DIR/../ansible"

cd "$TERRAFORM_DIR"

# Initialize and validate Terraform
terraform init
terraform validate || (echo "Terraform config is invalid!" && exit 1)
echo "Validated terraform configuration"

# Apply Terraform
terraform apply --var-file=secret.tfvars --auto-approve
echo "Created cloud infrastructure"

# Get IPs from Terraform output
ext_ip=$(terraform output -raw external_ip)
int_ip=$(terraform output -raw internal_ip)

# Generate Ansible inventory
cat << EOF > "$ANSIBLE_DIR/inventory.yaml"
all:
  hosts:
    monitoring:
      ansible_host: ${ext_ip}
      internal_ip: ${int_ip}
      external_ip: ${ext_ip}
EOF
echo "Generated Ansible inventory"

echo ""
echo "=== Infrastructure Ready ==="
echo "Monitoring VM: ${ext_ip} (external) / ${int_ip} (internal)"
echo ""
echo "Run 'make install' to deploy monitoring stack"
