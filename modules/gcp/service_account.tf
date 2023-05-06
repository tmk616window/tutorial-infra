resource "google_service_account" "tnamba_tutorial_cloudrun_service_account" {
  account_id   = "tnamba-tutorial-cloudrun-sa"
  display_name = "Various permissions required for Cloud Run"
}

resource "google_service_account" "tnamba_tutorial_ga_service_account" {
  account_id   = "tnamba-tutorial-ga-sa"
  display_name = "Various permissions required for Github Actions"
}

resource "google_project_iam_member" "ga_storage_object_viewer" {
  project = var.project_id
  role    = "roles/clouddeploy.operator"
  member  = "serviceAccount:${google_service_account.tnamba_tutorial_ga_service_account.email}"
}

resource "google_service_account_iam_member" "tnamba_tutorial_ga_iam_workload_identity_user" {
  service_account_id = google_service_account.tnamba_tutorial_ga_service_account.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_num}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.tnamba_tutorial_ga.workload_identity_pool_id}/attribute.repository/tmk616window/tutorial2-backend-go-hasura"
}
