terraform {
  backend "gcs" {
    bucket = "e-conomic-hiring-assignment-tf-state"
    prefix = "prod"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}
