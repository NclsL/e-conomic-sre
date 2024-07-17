data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.default.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

resource "kubernetes_deployment_v1" "default" {
  metadata {
    name = "api-deployment"
  }
  spec {
    selector {
      match_labels = { app = "api-app" }
    }
    template {
      metadata {
        labels = { app = "api-app" }
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
          image = "europe-north1-docker.pkg.dev/sre-hiring-assignment/api-docker-registry/api:${var.deployed-tag}"
          name  = "api-container"
          port {
            container_port = 8000
            name           = "api-svc"
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
          liveness_probe {
            http_get {
              path = "/health"
              port = 8000
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = 8000
            }
            initial_delay_seconds = 10
            period_seconds        = 10

          }
        }
      }
    }
  }
}

resource "time_sleep" "wait_service_cleanup" {
  depends_on       = [google_container_cluster.default]
  destroy_duration = "180s"

}

resource "kubernetes_ingress_v1" "default" {
  metadata {
    name = "api-ingress"
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.default.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "default" {
  metadata {
    name = "api-app-svc"
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.default.spec[0].selector[0].match_labels.app
    }
    ip_family_policy = "RequireDualStack"

    port {
      port = 80
      target_port = 8000
    }
    type = "NodePort"
  }

  depends_on = [time_sleep.wait_service_cleanup]
}
