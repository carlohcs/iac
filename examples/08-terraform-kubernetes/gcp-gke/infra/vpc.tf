resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.gcp_id}-subnet"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.10.0.0/24"
}