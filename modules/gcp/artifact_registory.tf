resource "google_artifact_registry_repository" "tnamba_tutorial_sidecar" {
  provider      = google
  location      = var.region
  repository_id = "tnamba-tutorial-sidecar"
  description   = "docker repository to sidecar"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "tnamba_tutorial_hasura" {
  provider      = google
  location      = var.region
  repository_id = "tnamba-tutorial-hasura"
  description   = "docker repository to hasura"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_binding" "hasura_admin" {
  provider   = google
  location   = google_artifact_registry_repository.tnamba_tutorial_hasura.location
  repository = google_artifact_registry_repository.tnamba_tutorial_hasura.name
  role       = "roles/artifactregistry.admin"

  members = [
    "serviceAccount:id-terraform-t-namba-tutorial@tech-lab-323207.iam.gserviceaccount.com"
  ]
}

resource "google_artifact_registry_repository_iam_binding" "admin" {
  provider   = google
  location   = google_artifact_registry_repository.tnamba_tutorial_sidecar.location
  repository = google_artifact_registry_repository.tnamba_tutorial_sidecar.name
  role       = "roles/artifactregistry.admin"

  members = [
    "serviceAccount:id-terraform-t-namba-tutorial@tech-lab-323207.iam.gserviceaccount.com"
  ]
}
