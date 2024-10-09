
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

resource "google_service_account" "default" {
  account_id   = "cloud-run-service-account"
  display_name = "Cloud Run Service Account"
}

resource "google_project_iam_member" "vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.default.email}"
}


resource "google_cloud_run_v2_service" "default" {
  name     = "gdev-gemini-app"
  location = var.region
  template {
      service_account = google_service_account.default.email
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
