module "development" {
  source = "../../infra"

  application_name = "application-gcp-dev"
  application_description = "An GCP application for development"
  application_environment = "development"
  gcp_id = "thermal-micron-427901-e1"
  gcp_region = "us-central1"
  gcp_zone = "us-central1-a"

  # PodUnschedulable: Cannot schedule pods: Insufficient cpu.
  # PodUnschedulable: Cannot schedule pods: Insufficient memory.
  # Cannot schedule pods: No preemption victims found for incoming pod.
  # https://gcloud-compute.com/instances.html
  # Known more: https://cloud.google.com/kubernetes-engine/docs/troubleshooting?hl=pt_BR&_gl=1*14yx0xu*_ga*MTYyOTQ4MjQ5Ni4xNzIzMzg4MzQz*_ga_WH2QY8WWF5*MTcyNTMyMjc3Mi44LjEuMTcyNTMyMzY2Ny40LjAuMA..#PodUnschedulable
  # gcp_instance_type = "e2-micro"
  # gcp_instance_type = "e2-small"
  gcp_instance_type = "e2-medium"
  # gke_num_nodes = 1
  gke_num_nodes = 2
}