resource "google_iam_workload_identity_pool" "tnamba_tutorial_ga" {
  workload_identity_pool_id = "tnamba-tutorial-pool"
}

resource "google_iam_workload_identity_pool_provider" "tnamba_tutorial_ga_pool_provider" {
  workload_identity_pool_provider_id = "tnamba-tutorial-ga-pool-provider"
  workload_identity_pool_id          = google_iam_workload_identity_pool.tnamba_tutorial_ga.workload_identity_pool_id

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
  }
}
