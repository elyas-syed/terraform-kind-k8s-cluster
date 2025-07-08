# kind-terraform-k8s-cluster

Terraform configuration to create and manage a local Kubernetes cluster using Kind (Kubernetes in Docker).

## Prerequisites

- Docker installed and running
- kubectl installed
- Kind installed (see [Kind Installation Guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
- Terraform installed

## Usage

1. Clone this repository
2. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Create the cluster:
   ```bash
   terraform apply
   ```
5. To delete the cluster:
   ```bash
   terraform destroy
   ```

## Configuration

The Kind cluster configuration is defined in `kind/kind-config.yaml`. Modify this file to customize your cluster setup.