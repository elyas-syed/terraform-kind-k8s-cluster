#!/bin/bash

# Test Workflow Script for Kind Terraform K8s Cluster
# This script tests the complete workflow: cluster creation → ArgoCD bootstrap → verification

set -e  # Exit on error

echo "=========================================="
echo "Testing Kind Terraform K8s Cluster Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check Docker
if ! docker ps > /dev/null 2>&1; then
    echo -e "${RED}ERROR: Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}ERROR: kubectl is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ kubectl is installed${NC}"

# Check kind
if ! command -v kind &> /dev/null; then
    echo -e "${RED}ERROR: kind is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ kind is installed${NC}"

# Check terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}ERROR: terraform is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ terraform is installed${NC}"

echo ""
echo -e "${YELLOW}Step 1: Creating Kind cluster...${NC}"
cd terraform

# Initialize if needed
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Create cluster
echo "Applying Terraform configuration to create cluster..."
terraform apply -auto-approve

# Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
sleep 10

# Verify cluster
echo "Verifying cluster..."
kubectl get nodes
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Cluster created successfully${NC}"
else
    echo -e "${RED}ERROR: Failed to verify cluster${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Step 2: Bootstrapping ArgoCD...${NC}"
cd ../bootstrap

# Initialize if needed
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Deploy ArgoCD
echo "Applying Terraform configuration to deploy ArgoCD..."
terraform apply -auto-approve

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready (this may take a few minutes)..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd || {
    echo -e "${YELLOW}Warning: ArgoCD deployment timeout. Checking status...${NC}"
    kubectl get pods -n argocd
}

# Verify ArgoCD pods
echo "Verifying ArgoCD pods..."
kubectl get pods -n argocd
if kubectl get pods -n argocd | grep -q "Running"; then
    echo -e "${GREEN}✓ ArgoCD deployed successfully${NC}"
else
    echo -e "${YELLOW}Warning: Some ArgoCD pods may not be running yet${NC}"
fi

echo ""
echo -e "${YELLOW}Step 3: Verification${NC}"

# Get ArgoCD admin password
echo "Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 -d || echo "Password not available yet")

echo ""
echo "=========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Cluster Information:"
echo "  - Cluster Name: terraform-kind-cluster"
echo "  - Context: kind-terraform-kind-cluster"
echo ""
echo "ArgoCD Access:"
echo "  - URL: http://localhost:30020"
echo "  - Username: admin"
if [ -n "$ARGOCD_PASSWORD" ] && [ "$ARGOCD_PASSWORD" != "Password not available yet" ]; then
    echo "  - Password: $ARGOCD_PASSWORD"
else
    echo "  - Password: (Run: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)"
fi
echo ""
echo "Useful Commands:"
echo "  - View nodes: kubectl get nodes"
echo "  - View ArgoCD pods: kubectl get pods -n argocd"
echo "  - View ArgoCD services: kubectl get svc -n argocd"
echo "  - Set context: kubectl config use-context kind-terraform-kind-cluster"
echo ""
echo "To clean up:"
echo "  1. cd bootstrap && terraform destroy -auto-approve"
echo "  2. cd ../terraform && terraform destroy -auto-approve"
echo ""

