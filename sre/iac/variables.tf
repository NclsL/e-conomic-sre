variable "region" {
  type        = string
  description = "Google project region"
}

variable "project" {
  type        = string
  description = "Project ID"
}

variable "tf-state-bucket" {
  type        = string
  description = "Project ID"
}

variable "deployed-tag" {
  type        = string
  description = "Tag of currently deployed image"
}
