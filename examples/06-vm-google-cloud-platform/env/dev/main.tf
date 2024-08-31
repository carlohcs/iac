module "development" {
  source = "../../infra"

  application_name = "application-gcp-dev"
  application_description = "An GCP application for development"
  application_environment = "development"
  gcp_id = "thermal-micron-427901-e1"
  gcp_region = "us-central1"
  gcp_zone = "us-central1-a"
  gcp_instance_type = "e2-micro"
}