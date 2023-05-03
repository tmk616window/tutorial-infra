resource "google_cloud_run_service" "tnamba_tutorial_sidecar" {
  name     = "tnamba-tutorial-sidecar"
  location = "asia-northeast1"

  template {
    spec {
      containers {
        image = "gcr.io/tech-lab-323207/pro-traning-b:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
