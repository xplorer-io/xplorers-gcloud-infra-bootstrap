output github_actions_identity_pool_name {
  description = "Pool name"
  value       = google_iam_workload_identity_pool.github_actions_identity_pool.name
}

output github_actions_identity_pool_provider_name {
  description = "Provider name"
  value       = google_iam_workload_identity_pool_provider.github_actions_identity_pool_provider.name
}

output github_actions_service_account_name {
  description = "Github Actions service account name"
  value       = google_service_account.github_actions_service_account.name
}
