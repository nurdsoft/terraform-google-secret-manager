output "secret_id" {
  description = "The short ID of the secret."
  value       = google_secret_manager_secret.this.secret_id
}

output "secret_name" {
  description = "Full resource name of the secret (projects/{project}/secrets/{secret_id})."
  value       = google_secret_manager_secret.this.name
}

output "secret_version_id" {
  description = "Full resource name of the secret version (projects/{project}/secrets/{secret_id}/versions/{version})."
  value       = google_secret_manager_secret_version.this.name
}
