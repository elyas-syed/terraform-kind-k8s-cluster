#!/bin/bash
set -e

if ! command -v kind &> /dev/null; then
  echo "Installing Kind..."
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  ARCH=$([ $(uname -m) = x86_64 ] && echo amd64 || echo arm64)
  curl -sSfLo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-${OS}-${ARCH}"
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
else
  echo "Kind is already installed."
fi