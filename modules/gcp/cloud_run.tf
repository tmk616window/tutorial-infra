resource "google_cloud_run_service" "tnamba_tutorial_sidecar" {
  name     = "tnamba-tutorial-sidecar"
  location = var.region
  template {
    spec {
      service_account_name = google_service_account.tnamba_tutorial_cloudrun_service_account.email
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/tnamba-tutorial-sidecar/sidecar-image:latest"

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
        env {
          name  = "DB_PORT"
          value = 5432
        }
        env {
          name  = "ENV"
          value = var.env
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "3"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.tnamba_tutorial_postgres.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "tnamba_tutorial_hasura" {
  name     = "tnamba-tutorial-hasura"
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }
  template {
    spec {
      service_account_name = google_service_account.tnamba_tutorial_cloudrun_service_account.email
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/tnamba-tutorial-hasura/hasura-image:latest"
        // 公式ドキュメントでは環境変数がINSTANCE_UNIX_SOCKETとなっているが、環境差分をなくすためDB_HOSTと奥
        env {
          name  = "HASURA_GRAPHQL_DATABASE_URL"
          value = "postgres://postgres:9f7e9f9e7fa96755@/tnamba-tutorial?host=/cloudsql/tech-lab-323207:asia-northeast1:tnamba-tutorial-postgres"
          # value = "/cloudsql/${google_sql_database_instance.tnamba_tutorial_postgres.connection_name}"
        }
        env {
          name  = "HASURA_GRAPHQL_ADMIN_SECRET"
          value = "secret"
        }
        env {
          name  = "HASURA_GRAPHQL_ENABLE_CONSOLE"
          value = true
        }
        env {
          name  = "ENV"
          value = var.env
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "3"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.tnamba_tutorial_postgres.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloud_run_service.tnamba_tutorial_hasura.location
  project  = google_cloud_run_service.tnamba_tutorial_hasura.project
  service  = google_cloud_run_service.tnamba_tutorial_hasura.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
