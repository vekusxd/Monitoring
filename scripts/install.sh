#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR/../ansible"

cd "$ANSIBLE_DIR"

echo "Waiting 30 seconds for VM to be fully ready..."
sleep 30

echo "Installing Docker and deploying monitoring stack..."
ansible-playbook -i inventory.yaml playbook.yaml

# Get IP from inventory
VM_IP=$(grep 'ansible_host:' inventory.yaml | awk '{print $2}')

echo ""
echo "=== Monitoring Stack Deployed ==="
echo "Grafana: http://${VM_IP}:3000 (admin/admin)"
echo "Prometheus: http://${VM_IP}:9090"
echo "Alertmanager: http://${VM_IP}:9093"
