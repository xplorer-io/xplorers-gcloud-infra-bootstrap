############################# ENABLE APIS #############################

resource "google_project_service" "services" {
  for_each                   = toset(var.service_apis_to_enable)
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
}

############################# Github Actions #############################

resource "google_service_account" "github_actions_service_account" {
  project      = var.project_id
  account_id   = var.github_actions_service_account_id
  display_name = var.github_actions_service_account_display_name
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions_service_account.name
  role               = var.workload_identity_user_role
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions_identity_pool.name}/attribute.repository/${var.github_organisation}/xplorers-gcloud-infra-bootstrap"
}

resource "google_project_iam_member" "github_actions_service_account_role_binding" {
  project = var.project_id
  role    = var.github_actions_cloudfunctions_role
  member = "serviceAccount:${google_service_account.github_actions_service_account.email}"
}

resource "google_iam_workload_identity_pool" "github_actions_identity_pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
}

resource "google_iam_workload_identity_pool_provider" "github_actions_identity_pool_provider" {
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  attribute_mapping                  = var.attribute_mapping
  oidc {
    issuer_uri        = var.issuer_uri
  }
}
