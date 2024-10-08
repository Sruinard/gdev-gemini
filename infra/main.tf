
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_v2_service" "default" {
  name     = "gdev-gemini-app"
  location = var.region
  template {
    
      containers {
        image = "gcr.io/cloudrun/hello"
        ports {
          container_port = 8080
        }
      }
      labels = {
        "gdev_services" = "gems_app"
      }
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}
