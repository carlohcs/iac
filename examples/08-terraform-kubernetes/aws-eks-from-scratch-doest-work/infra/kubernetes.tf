
# ----------------------------------------------------------
resource "kubernetes_pod" "basic_app_pod" {
  metadata {
    name      = "pod-basic-app"
    namespace = "default"
  }

  spec {
    container {
      name  = "pod-basic-app-container"
      image = "carlohcs/basic-app"

      resources {
        limits = {
          memory = "128Mi"
          cpu    = "500m"
        }
      }

      port {
        container_port = 3000
      }

      liveness_probe {
        http_get {
          path = "/"
          port = 3000
        }
        initial_delay_seconds = 3
        period_seconds        = 3
      }
    }
  }

  depends_on = [aws_eks_node_group.basic_app_node_group]
}

resource "kubernetes_deployment" "deployment_basic_app" {
  metadata {
    name      = "deployment-basic-app"
    namespace = "default"
  }

  spec {
    selector {
      match_labels = {
        app = "deployment-basic-app"
      }
    }

    replicas = 2 # Adiciona o número de réplicas desejado

    template {
      metadata {
        labels = {
          app = "deployment-basic-app"
        }
      }

      spec {
        // Prevent error:
        // 0/2 nodes are available: 2 node(s) were unschedulable. 
        // preemption: 0/2 nodes are available: 2 
        // Preemption is not helpful for scheduling.
        toleration {
          key      = "key"
          operator = "Equal"
          value    = "value"
          effect   = "NoSchedule"
        }

        container {
          name  = "deployment-basic-app-container"
          image = "carlohcs/basic-app"

          resources {
            limits = {
              memory = "128Mi"
              cpu    = "500m"
            }
          }

          port {
            container_port = 3000
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }

  depends_on = [kubernetes_pod.basic_app_pod]
}

resource "kubernetes_service" "basic_app_service" {
  metadata {
    name      = "svc-basic-app"
    namespace = "default"
  }
  spec {
    selector = {
      nome = "deployment-basic-app"
    }
    port {
      port        = 3000
      target_port = 30001
    }
    type = "LoadBalancer"
  }

  # lifecycle {
  #   ignore_changes = [
  #     metadata[0].annotations,
  #     spec[0].cluster_ip,
  #     spec[0].external_ips,
  #     spec[0].load_balancer_ip,
  #     spec[0].load_balancer_source_ranges,
  #     spec[0].port,
  #     spec[0].selector,
  #     spec[0].session_affinity,
  #     spec[0].type,
  #   ]
  # }

  depends_on = [kubernetes_deployment.deployment_basic_app]
}

# resource "kubernetes_ingress" "basic_app_ingress" {
#   metadata {
#     name      = "ingress-basic-app"
#     namespace = "default"
#   }

#   spec {
#     rule {
#       http {
#         path {
#           path = "/"
#           backend {
#             service_name = kubernetes_service.basic_app_service.metadata[0].name
#             service_port = 3000
#           }
#         }
#       }
#     }
#   }
# }

# Failed to create Ingress 'default/ingress-basic-app' because: the server could not find the requested resource (post ingresses.extensions)
resource "kubernetes_ingress_v1" "basic_app_ingress" {
  metadata {
    name      = "ingress-basic-app"
    namespace = "default"
  }

  # depends_on = [kubernetes_service.basic_app_service]

  spec {
    default_backend {
      service {
        name = kubernetes_service.basic_app_service.metadata[0].name
        port {
          number = kubernetes_service.basic_app_service.spec[0].port[0].port
        }
      }
    }
  }
}

data "kubernetes_service" "basic_app_service_data" {
  metadata {
    name      = kubernetes_service.basic_app_service.metadata[0].name
    namespace = kubernetes_service.basic_app_service.metadata[0].namespace
  }
}

output "URL" {
  value = data.kubernetes_service.basic_app_service_data.status[0].load_balancer[0].ingress[0].hostname
}
