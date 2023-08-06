############################# ENABLE APIS #############################

resource "google_project_service" "services" {
  for_each                   = toset(var.service_apis_to_enable)
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
}

############################# Github Actions #############################

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = var.project_id
  pool_id     = var.pool_id
  provider_id = var.provider_id
  sa_mapping = {
    "github_actions_service_account_repository_mapping" = {
      sa_name   = google_service_account.github_actions_service_account.name
      attribute = "attribute.repository/${var.github_organisation}/${var.github_repository}"
    }
  }
}

resource "google_service_account" "github_actions_service_account" {
  project      = var.project_id
  account_id   = var.github_actions_service_account_id
  display_name = var.github_actions_service_account_display_name
}

resource "google_project_iam_custom_role" "github_actions_storage_role" {
  role_id     = "github_actions_role_for_storage_access"
  title       = "Role for Github Actions to interact with storage service"
  description = "Role for Github Actions to interact with storage service"
  permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
    "storage.buckets.getIamPolicy",
    "storage.buckets.setIamPolicy"
  ]
}

resource "google_project_iam_member" "github_actions_storage_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.github_actions_storage_role.name
  member  = "serviceAccount:${google_service_account.github_actions_service_account.email}"

  condition {
    title       = "allow_access_to_xplorers_bucket_only"
    description = "Allow Github Actions service account to interact only with xplorers artifact bucket"
    expression  = "resource.name == \"projects/_/buckets/${var.artifacts_bucket_name}\" && resource.type == \"storage.googleapis.com/Bucket\" || resource.type == \"storage.googleapis.com/Object\""
  }
}

resource "google_project_iam_custom_role" "github_actions_custom_role" {
  role_id     = "github_actions_role_for_gcp_services"
  title       = "Role for Github Actions to interact with gcp services"
  description = "Role for Github Actions to interact with gcp services"
  permissions = [
    "cloudfunctions.functions.get",
    "cloudfunctions.functions.delete",
    "cloudfunctions.functions.create",
    "cloudfunctions.functions.update",
    "cloudfunctions.operations.get",
    "cloudfunctions.functions.getIamPolicy",
    "cloudfunctions.functions.setIamPolicy",
    "iam.roles.get",
    "iam.roles.undelete",
    "iam.roles.update",
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "cloudtasks.queues.get",
    "cloudtasks.queues.create",
    "cloudtasks.queues.delete",
    "cloudtasks.queues.update"
  ]
}

resource "google_project_iam_member" "github_actions_custom_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.github_actions_custom_role.name
  member  = "serviceAccount:${google_service_account.github_actions_service_account.email}"
}
