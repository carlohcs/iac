# provider "kubectl" {
#   # host                   = data.google_container_cluster.primary.endpoint
#   # cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
#   # token                  = data.google_container_cluster_auth.primary.access_token
#   # load_config_file       = false
# }

# One app
# resource "kubectl_manifest" "basic_app" {
#   yaml_body = file("${path.module}/my_service.yaml")
# }

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest
# https://github.com/gavinbunney/terraform-provider-kubectl/blob/master/docs/data-sources/kubectl_path_documents.md#load-all-manifest-documents-via-for_each-recommended
# Multiple
# data "kubectl_filename_list" "manifests" {
#   pattern = "./k8s/*.yaml"
# }

# resource "kubectl_manifest" "basic_app" {
#   count = length(data.kubectl_filename_list.manifests.matches)
#   yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
# }

# output "kubectl_manifest_files" {
#   value       = data.kubectl_filename_list.manifests.matches
# }

