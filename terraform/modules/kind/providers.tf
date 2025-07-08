terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.4.0"
    }
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


