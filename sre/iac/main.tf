terraform {
  backend "gcs" {
    bucket = "e-conomic-hiring-assignment-tf-state"
    prefix = "production"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}
