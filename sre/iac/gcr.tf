resource "google_artifact_registry_repository" "api-docker-registry" {
  location      = var.region
  repository_id = "api-docker-registry"
  description   = "Docker registry for sre hiring assignment"
  format        = "DOCKER"
}
