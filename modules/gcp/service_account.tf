resource "google_service_account" "tnamba_tutorial_cloudrun_service_account" {
  account_id   = "tnamba-tutorial-cloudrun-sa"
  display_name = "Various permissions required for Cloud Run"
}
