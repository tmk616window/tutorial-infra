resource "google_sql_database_instance" "tnamba_tutorial_postgres" {
  name             = "tnamba-tutorial-postgres"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    disk_size = "10"
    disk_type = "PD_HDD"
    availability_type = "ZONAL"
    disk_autoresize = false
  }

  deletion_protection = "false"
}

# resource "google_sql_database_instance" "tnamba_tutorial_sql" {
# }



resource "google_sql_database" "tnamba_tutorial_database" {
  name     = "tnamba-tutorial"
  instance = google_sql_database_instance.tnamba_tutorial_postgres.name

  depends_on = [google_sql_user.default_user]
}

resource "google_sql_user" "default_user" {
  name     = "postgres"
  password = random_id.length_8.hex
  instance = google_sql_database_instance.tnamba_tutorial_postgres.name
}

resource "google_project_iam_binding" "tnamba_tutorial_chat_image_object_admin" {
  project = var.project_id  
  role = "roles/cloudsql.instanceUser"
  members = [
    "serviceAccount:${google_service_account.tnamba_tutorial_cloudrun_service_account.email}",
  ]
}

resource "google_project_iam_binding" "client" {  
 project = var.project_id
 role = "roles/cloudsql.client"
 members = [
  "serviceAccount:${google_service_account.tnamba_tutorial_cloudrun_service_account.email}",
 ]
}
