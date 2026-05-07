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

variable "secret_version_deletion_policy" {
  description = "Deletion policy applied to the secret version when it is replaced. \"DISABLE\" keeps the old version recoverable; \"DELETE\" permanently removes it; \"ABANDON\" removes it from Terraform state without destroying it in GCP (intended for import/migration scenarios only)."
  type        = string
  default     = "DISABLE"

  validation {
    condition     = contains(["DELETE", "DISABLE", "ABANDON"], var.secret_version_deletion_policy)
    error_message = "secret_version_deletion_policy must be one of: DELETE, DISABLE, ABANDON."
  }
}

variable "labels" {
  description = "Labels to apply to the secret."
  type        = map(string)
  default     = {}
}
