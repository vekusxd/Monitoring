#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/../terraform"

cat << EOF > "$TERRAFORM_DIR/secret.tfvars"
yc_token = "$(yc iam create-token)"
yc_cloud_id = "$(yc config get cloud-id)"
yc_folder_id = "$(yc config get folder-id)"
EOF

echo "Acquired YC token, cloud and folder IDs!"
