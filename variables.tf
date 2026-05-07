variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "secret_id" {
  description = "The ID of the secret. Must be unique within the project."
  type        = string
}

variable "replication_type" {
  description = "Replication policy for the secret. Use \"automatic\" for Google-managed replication across regions or \"user_managed\" to specify explicit replica locations."
  type        = string
  default     = "automatic"

  validation {
    condition     = contains(["automatic", "user_managed"], var.replication_type)
    error_message = "replication_type must be one of: automatic, user_managed."
  }
}

variable "replication_locations" {
  description = "List of GCP regions to replicate the secret into. Required when replication_type is \"user_managed\"."
  type        = list(string)
  default     = []
}

variable "secret_data" {
  description = "The secret payload to store in the secret version."
  type        = string
  sensitive   = true
}

variable "labels" {
  description = "Labels to apply to the secret."
  type        = map(string)
  default     = {}
}
