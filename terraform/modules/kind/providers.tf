terraform {
  required_version = ">= 1.3.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.21.1"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-${var.cluster_name}"
}

provider "helm" {
}
