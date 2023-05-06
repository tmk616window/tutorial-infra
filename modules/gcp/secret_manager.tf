# data "google_secret_manager_secret" "portal_secret_hasura_graphql_admin_secret" {
#   secret_id = "PORTAL_HASURA_GRAPHQL_ADMIN_SECRET"
# }

# resource "google_secret_manager_secret_iam_binding" "portal_secret_hasura_graphql_admin_secret_access" {
#   secret_id = data.google_secret_manager_secret.portal_secret_hasura_graphql_admin_secret.secret_id
#   role      = "roles/secretmanager.secretAccessor"
#   members = [
#     "serviceAccount:${google_service_account.portal_cloudrun_service_account.email}"
#   ]
# }
