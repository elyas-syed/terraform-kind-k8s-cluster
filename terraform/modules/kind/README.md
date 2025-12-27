# Kind Cluster Terraform Module

This module creates and manages a Kind (Kubernetes in Docker) cluster using Terraform.

## Prerequisites

- Docker installed and running
- Kind CLI (optional, but recommended for troubleshooting)
- Terraform >= 1.3.0

## Usage

```hcl
module "kind_cluster" {
  source = "./modules/kind"

  cluster_name = "my-cluster"
}
```

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| cluster_name | Name of the Kind cluster | string | yes | - |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | The name of the created Kind cluster |
| kubeconfig_path | The path to the kubeconfig file |
| kubectl_context | The kubectl context name for the cluster (format: `kind-{cluster_name}`) |
| endpoint | The Kubernetes API server endpoint |
| success_message | Confirmation message that the cluster was created |

## Cluster Configuration

The module creates a cluster with:
- 1 control-plane node
- 2 worker nodes
- Port mappings:
  - 30001 (NodePort services)
  - 30020 (ArgoCD server)
  - 30030, 30040, 30050 (reserved for future use)

The cluster configuration is defined inline in the module. To modify the configuration, edit `main.tf` in this module.