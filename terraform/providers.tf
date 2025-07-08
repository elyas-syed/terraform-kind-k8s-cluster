terraform {
  required_version = ">= 1.3.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
    
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.4.0"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.21.1"
    }
    
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.1"
    }
  }
}


provider "kind" {  
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}