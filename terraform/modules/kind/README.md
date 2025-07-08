# Kind Cluster Terraform Module

This module creates and manages a Kind (Kubernetes in Docker) cluster using Terraform.

## Prerequisites

- Docker
- Kind CLI
- Terraform

## Usage

```hcl
module "kind_cluster" {
  source = "./modules/kind"

  cluster_name = "my-cluster"
  config_path  = "path/to/kind-config.yaml"
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------||
| cluster_name | Name of the Kind cluster | string | yes |
| config_path | Path to the Kind cluster configuration file | string | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | The name of the created Kind cluster |
| config_path | The path to the Kind cluster configuration file used |