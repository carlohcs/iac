# If you want to create a new namespace, uncomment the code below
# resource "kubernetes_namespace" "basic_app_namespace" {
#   metadata {
#     name = var.kubernetes_namespace
#   }
# }

resource "kubernetes_deployment" "deployment_basic_app" {
  metadata {
    name = "deployment-basic-app"
    # namespace = kubernetes_namespace.basic_app_namespace.metadata.0.name
    namespace = var.kubernetes_namespace
    # namespace = "default"
  }

  spec {
    selector {
      match_labels = {
        app = "deployment-basic-app"
      }
    }

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

          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = 3000
          #   }
          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }

  # depends_on = [kubernetes_pod.basic_app_pod]
}

resource "kubernetes_service" "basic_app_service" {
  metadata {
    name = "service-basic-app"
    # namespace = kubernetes_namespace.basic_app_namespace.metadata.0.name
    namespace = var.kubernetes_namespace
    # namespace = "default"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      # "service.beta.kubernetes.io/aws-load-balancer-type" : "external"
      # "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" : "ip"
      # "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "deployment-basic-app"
    }
    port {
      # port        = 80
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}

# Failed to create Ingress 'default/ingress-basic-app' because: the server could not find the requested resource (post ingresses.extensions)
# So let's use kubernetes_ingress_v1 instead of kubernetes_ingress
resource "kubernetes_ingress_v1" "basic_app_ingress" {
  metadata {
    name      = "ingress-basic-app"
    # namespace = kubernetes_namespace.basic_app_namespace.metadata.0.name
    namespace = var.kubernetes_namespace
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
