#!/bin/bash

###############################################
# Author: Harish Sheoran
# Purpose: Create Policy and attach to App Role
# Date: 16th April, 2024
# Version: v1.0.0
###############################################

set -e

export VAULT_ADDR='http://0.0.0.0:8200'

# Create Policy, so that terraform can access
vault policy write terraform - <<EOF
path "*" {
  capabilities = ["list", "read"]
}

path "secrets/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
capabilities = ["create", "read", "update", "list"]
}
EOF

# Create role and attach the policy
vault write auth/approle/role/terraform \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=terraform


# Read role ID
vault read auth/approle/role/terraform/role-id

# Read Secret ID
vault write -f auth/approle/role/terraform/secret-id
