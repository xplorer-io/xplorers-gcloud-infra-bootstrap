variable "project_id" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "region" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "artifacts_bucket_name" {
  type      = string
  sensitive = false
  nullable  = true
}

variable "zone" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "service_apis_to_enable" {
  type = list(any)
  default = [
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

variable "github_organisation" {
  type      = string
  sensitive = true
  nullable  = false
}

variable "github_repository" {
  type      = string
  sensitive = true
  nullable  = false
}

###################### GITHUB ACTIONS ######################

variable "pool_id" {
  type        = string
  description = "Workload Identity Pool ID"
  default     = "github-actions-pool"
}

variable "provider_id" {
  type        = string
  description = "Workload Identity Pool Provider id"
  default     = "github-actions-provider"
}

variable "github_actions_service_account_id" {
  type        = string
  description = "Github Actions service account id"
  default     = "github-actions-service-account"
}

variable "github_actions_service_account_display_name" {
  type        = string
  description = "Github Actions service account name display name"
  default     = "Service Account used for GitHub Actions"
}
