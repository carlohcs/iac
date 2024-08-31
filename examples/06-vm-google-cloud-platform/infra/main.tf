# Ref: https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("~/.gcp/credentials.json")

  project = var.gcp_id # "thermal-micron-427901-e1"
  region  = var.gcp_region # "us-central1"
  zone    = var.gcp_zone # "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# ----

resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name         = var.application_name
  machine_type = var.gcp_instance_type
  zone         = var.gcp_zone

  # tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "application-disk"
      }
    }
  }

  // Local SSD disk
  # scratch_disk {
  #   interface = "NVME"
  # }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  # metadata = {
  #   foo = "bar"
  # }

  metadata_startup_script = "echo hi > /test.txt"

  # We already have everything we need in the service account
  # service_account {
  #   # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #   email  = google_service_account.default.email
  #   scopes = ["cloud-platform"]
  # }
}


# https://registry.terraform.io/providers/hashicorp/google/latest
# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance