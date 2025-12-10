.PHONY: all up down cloud-up acquire-tokens install

# Default target
all: up

# Full deployment: infrastructure + monitoring stack
up: cloud-up install
	@echo "Monitoring stack is ready!"

# Only create infrastructure
cloud-up: acquire-tokens
	./scripts/cloud_up.sh

# Get YC tokens
acquire-tokens:
	./scripts/acquire_tokens.sh

# Install monitoring on existing infrastructure
install:
	./scripts/install.sh

# Destroy infrastructure
down:
	./scripts/cloud_down.sh
