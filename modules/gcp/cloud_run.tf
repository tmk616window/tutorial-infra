resource "google_cloud_run_service" "tnamba_tutorial_sidecar" {
  name     = "tnamba-tutorial-sidecar"
  location = "asia-northeast1"
  
  template {
    spec {
      containers {
        image = "gcr.io/tech-lab-323207/pro-traning-b:latest"

        // 公式ドキュメントでは環境変数がINSTANCE_UNIX_SOCKETとなっているが、環境差分をなくすためDB_HOSTと奥
        env {
          name  = "DB_HOST"
          value = "/cloudsql/${google_sql_database_instance.tnamba_tutorial_postgres.connection_name}"
        }
        env {
          name  = "DB_NAME"
          value = google_sql_database.tnamba_tutorial_database.name
        }
        env {
          name  = "DB_USER"
          value = google_sql_user.default_user.name
        }
        env {
          name  = "DB_PASSWORD"
          value = google_sql_user.default_user.password
        }
      }
    }
  }



  traffic {
    percent         = 100
    latest_revision = true
  }

  metadata {
    annotations = {
      "autoscaling.knative.dev/maxScale" = "1000"
      "run.googleapis.com/client-name" = "terraform"
      "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.tnamba_tutorial_postgres.connection_name
    }
  }
}
