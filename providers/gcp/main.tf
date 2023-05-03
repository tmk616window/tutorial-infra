provider "google" {
  project     = var.PROJECT_ID
  region      = var.REGION
  credentials = "./secrets/cd_service_account.json"
}

module "tutorial" {
    source = "../../modules/gcp"
    region                        = var.REGION
    project_id                    = var.PROJECT_ID

    cors_chat_image_bucket = [
      "http://localhost:3000",
    ]
}
