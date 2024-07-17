resource "kubernetes_deployment_v1" "dummy" {
  metadata {
    name = "dummy-pdf-or-png-deployment"
  }
  spec {
    selector {
      match_labels = { app = "dummy-pdf-or-png-app" }
    }
    template {
      metadata {
        labels = { app = "dummy-pdf-or-png-app" }
      }
      spec {
        security_context {
          run_as_non_root = true
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }
        toleration {
          effect   = "NoSchedule"
          key      = "kubernetes.io/arch"
          operator = "Equal"
          value    = "amd64"
        }
        container {
          image_pull_policy = "Always"
          image             = "europe-north1-docker.pkg.dev/sre-hiring-assignment/api-docker-registry/dummy-pdf-or-png:1.0"
          name              = "dummy-pdf-or-png-container"
          port {
            container_port = 3000
            name           = "dummy-port"
          }
          security_context {
            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = false
            capabilities {
              add  = []
              drop = ["NEW_RAW"]
            }
          }
        }
      }
    }
  }
}

# resource "kubernetes_ingress_v1" "dummy" {
#   metadata {
#     name = "dummy-pdf-or-png-ingress"
#   }
#   spec {
#     rule {
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = kubernetes_service.dummy.metadata[0].name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

resource "kubernetes_service" "dummy" {
  metadata {
    name = "dummy-pdf-or-png-app-svc"
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.dummy.spec[0].selector[0].match_labels.app
    }
    ip_family_policy = "RequireDualStack"

    port {
      port = 80
      # target_port = kubernetes_deployment_v1.dummy.spec[0].template[0].spec[0].container[0].port[0].name
      target_port = 3000
    }
    type = "NodePort"
  }

  depends_on = [time_sleep.wait_service_cleanup]
}
