# Ref: https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/main/gke.tf
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.6.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.10.0"
    }
  }
}

provider "google" {
  credentials = file("~/.gcp/credentials.json")

  project = var.gcp_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#   }
# }

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   # username = var.gke_username
#   # password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

output "providers_region" {
  value       = var.gcp_zone
  description = "GCloud Region"
}

output "providers_project_id" {
  value       = var.gcp_id
  description = "GCloud Project ID"
}

output "providers_kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "providers_kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}