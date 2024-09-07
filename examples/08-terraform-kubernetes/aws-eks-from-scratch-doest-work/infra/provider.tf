# Based on https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 4.16"
      version = "~> 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = "~> 1.10.0"
    # }
  }

  required_version = ">= 1.2.0"
}

# https://stackoverflow.com/a/55228111/3929980
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

provider "kubernetes" {
  host                   = aws_eks_cluster.basic_app_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.basic_app_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.basic_app_cluster_auth.token
}

# provider "kubectl" {
#   load_config_file = false
#   # config_path       = kind_cluster.main_cluster.kubeconfig_path
# }

## Pod
# resource "kubernetes_manifest" "basic_app_pod" {
#   provider = kubernetes
#   manifest = yamldecode(file("${path.module}/k8s/pod-app.yaml"))
# }

# ### Deployment
# resource "kubernetes_manifest" "basic_app_deployment" {
#   provider = kubernetes
#   manifest = yamldecode(file("${path.module}/k8s/deployment-app.yaml"))
# }

# ### Service (LoadBalancer)
# resource "kubernetes_manifest" "basic_app_service" {
#   provider = kubernetes
#   manifest = yamldecode(file("${path.module}/k8s/svc-app.yaml"))
# }

# ### Ingress
# resource "kubernetes_manifest" "basic_app_ingress" {
#   provider = kubernetes
#   manifest = yamldecode(file("${path.module}/k8s/ingress-app.yaml"))
# }
