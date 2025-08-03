#!/bin/bash

# Exit on error
set -e

# Configurations
SECRET_NAME="my-key-secret"
NAMESPACE="default"
PRIVATE_KEY_FILE="id_rsa"
PUBLIC_KEY_FILE="id_rsa.pub"
SECRET_YAML="secret.yaml"
SEALED_SECRET_YAML="sealed-secret.yaml"
GIT_COMMIT_MSG="Add sealed secret for key pair"

# Generate RSA key pair
echo "Generating RSA key pair..."
openssl genrsa -out "$PRIVATE_KEY_FILE" 2048
openssl rsa -in "$PRIVATE_KEY_FILE" -pubout -out "$PUBLIC_KEY_FILE"

# Create Kubernetes secret YAML
echo "Creating Kubernetes secret YAML..."
kubectl create secret generic "$SECRET_NAME" \
  --from-file=private_key="$PRIVATE_KEY_FILE" \
  --from-file=public_key="$PUBLIC_KEY_FILE" \
  --namespace="$NAMESPACE" \
  --dry-run=client -o yaml > "$SECRET_YAML"

# Seal the secret
echo "Sealing the secret..."
kubeseal --format=yaml < "$SECRET_YAML" > "$SEALED_SECRET_YAML"

# Clean up plaintext key files (optional for security)
rm -f "$PRIVATE_KEY_FILE" "$PUBLIC_KEY_FILE" "$SECRET_YAML"

# Add, commit, and push to GitHub
echo "Pushing sealed secret to GitHub..."
git add "$SEALED_SECRET_YAML"
git commit -m "$GIT_COMMIT_MSG"
git push

echo "✅ Done: Sealed secret pushed to GitHub!"

