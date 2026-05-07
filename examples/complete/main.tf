module "secret" {
  source = "git::https://github.com/nurdsoft/terraform-google-secret-manager.git?ref=v0.1.0"

  project_id  = "my-gcp-project"
  secret_id   = "my-app-secret"
  secret_data = jsonencode({ DB_HOST = "10.0.0.1", DB_NAME = "mydb" })

  replication_type      = "user_managed"
  replication_locations = ["us-central1", "us-east1"]

  secret_version_deletion_policy = "DISABLE"

  labels = {
    env  = "production"
    team = "platform"
  }
}
