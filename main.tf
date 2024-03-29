terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.26.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.KUBE_CONFIG_PATH
  }
}

resource "helm_release" "localstack" {
  name             = var.STACK_NAME
  namespace        = var.STACK_NAME
  create_namespace = true

  # repository = "https://helm.localstack.cloud"
  chart = "./charts/localstack"
}
