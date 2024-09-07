output "basic_app_ip" {
  value = data.kubernetes_service.basic_app_service_data.status[0].load_balancer[0].ingress[0].ip
}

output "basic_app_url" {
  value = data.kubernetes_service.basic_app_service_data.status[0].load_balancer[0].ingress[0].hostname
}

