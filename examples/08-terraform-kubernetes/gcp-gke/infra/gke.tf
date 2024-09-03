# From: https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/main/gke.tf

data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

# Doesn't exists anymore
# data "google_container_cluster_auth" "primary" {
#   name     = google_container_cluster.primary.name
#   location = google_container_cluster.primary.location
# }

resource "google_container_cluster" "primary" {
  name     = "${var.gcp_id}-gke"
  location = var.gcp_region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name


}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.name
  
  # version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  # Prevent error:
  #│ Error: error creating NodePool: googleapi: Error 400: Auto-upgrade is enabled, node version "1.27.16-gke.1008000" must be within one minor version of master version "1.29.7-gke.1104000".
  version = "1.29.7-gke.1104000"
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.gcp_id
    }

    # preemptible  = true
    # machine_type = "n1-standard-1"
    machine_type = var.gcp_instance_type
    tags         = ["gke-node", "${var.gcp_id}-gke"]

    # Avoid error:
    # Insufficient regional quota to satisfy request: resource "SSD_TOTAL_GB": request requires '600.0' and is short '100.0'. project has a quota of '500.0' with '500.0' available. 
    # View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=thermal-micron-427901-e1.
    # https://stackoverflow.com/a/78128483/3929980
    disk_type    = "pd-standard"  # Adiciona o tipo de disco pd-standard
    disk_size_gb = 20
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#using-the-kubernetes-and-helm-providers
# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.primary.endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
#   )
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "gke-gcloud-auth-plugin"
#   }
# }

# https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider
# https://github.com/hashicorp/terraform-provider-kubernetes-alpha/issues/44
provider "kubernetes" {
  load_config_file = "false"

  host     = google_container_cluster.primary.endpoint
  # username = var.gke_username
  # password = var.gke_password

  client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
  client_key             = google_container_cluster.primary.master_auth.0.client_key
  cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

# This is not working
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380
data "kubectl_path_documents" "k8s_files" {
  pattern = "./k8s/*.yaml"
}

resource "kubectl_manifest" "load_k8s_files" {
  for_each  = toset(data.kubectl_path_documents.k8s_files.documents)
  yaml_body = each.value
}

output "k8s_files" {
  value = data.kubectl_path_documents.k8s_files.documents
}