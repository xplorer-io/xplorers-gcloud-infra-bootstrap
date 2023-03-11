variable project_id {
  type             = string
  sensitive        = true
  nullable         = false
}

variable region {
  type             = string
  sensitive        = true
  nullable         = false
}

variable zone {
  type             = string
  sensitive        = true
  nullable         = false
}

variable service_apis_to_enable {
  type        = list
  default     = [
    "cloudresourcemanager.googleapis.com",
    "cloudfunctions.googleapis.com",
    "iam.googleapis.com"
  ]
}

variable github_organisation {
  type = string
  sensitive = true
  nullable = false
}

###################### GITHUB ACTIONS ######################

variable pool_display_name {
  type        = string
  description = "Workload Identity Pool display name"
  default     = "Github Actions Identity Pool"
}

variable pool_description {
  type        = string
  description = "Workload Identity Pool description"
  default     = "Identity pool used by Github Actions to perform deployments"
}

variable pool_id {
  type        = string
  description = "Workload Identity Pool ID"
  default     = "github-actions-identity-pool"
}

variable provider_id {
  type        = string
  description = "Workload Identity Pool Provider id"
  default = "github-actions-iam-provider"
}

variable provider_display_name {
  type        = string
  description = "Workload Identity Pool Provider display name"
  default     = "Github Actions IAM Provider"
}

variable provider_description {
  type        = string
  description = "Workload Identity Pool Provider description"
  default     = "Identity pool provider used by Github Actions to perform deployments"
}

variable attribute_mapping {
  type        = map(any)
  description = "Workload Identity Pool Provider attribute mapping. [More info](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider#attribute_mapping)"
  default = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
}

variable issuer_uri {
  type        = string
  description = "Workload Identity Pool Issuer URL"
  default     = "https://token.actions.githubusercontent.com"
}

variable github_actions_service_account_id {
  type = string
  description = "Github Actions service account id"
  default = "github-actions-service-account"
}

variable github_actions_service_account_display_name {
  type = string
  description = "Github Actions service account name display name"
  default = "Service Account used for GitHub Actions"
}

variable workload_identity_user_role {
  type = string
  description = "Workload Identity User Role"
  default = "roles/iam.workloadIdentityUser"
}

variable github_actions_cloudfunctions_role {
  type = string
  description = "Github Actions Cloud Functions role"
  default = "roles/cloudfunctions.developer"
}
