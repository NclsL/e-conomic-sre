terraform {
  required_version = "~>1.9.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.38.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }

  }
  backend "gcs" {
    bucket = "e-conomic-hiring-assignment-tf-state"
    prefix = "production"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}
