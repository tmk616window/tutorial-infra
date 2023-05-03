resource "google_storage_bucket" "tnamba_tutorial" {
  name          = "tnamba-tutorial-chat-image"
  location      = var.region
  force_destroy = true

  cors {
    origin          = var.cors_chat_image_bucket
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_binding" "tnamba_tutorial_chat_image_object_admin" {
  bucket = google_storage_bucket.tnamba_tutorial.name
  role = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.tnamba_tutorial_cloudrun_service_account.email}",
  ]
}
