resource "google_compute_network" "default" {
  name                     = "sre-hiring-assignment-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name             = "sre-hiring-assignment-subnetwork"
  ip_cidr_range    = "10.0.0.0/16"
  region           = var.region
  network          = google_compute_network.default.id
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
  secondary_ip_range {
    range_name    = "k8s-services-range"
    ip_cidr_range = "192.168.0.0/24"
  }

  secondary_ip_range {
    range_name    = "k8s-pods-range"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_container_cluster" "default" {
  name                     = "sre-hiring-assignment-cluster"
  location                 = var.region
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true
  network                  = google_compute_network.default.id
  subnetwork               = google_compute_subnetwork.default.id
  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }
  deletion_protection = false
}
