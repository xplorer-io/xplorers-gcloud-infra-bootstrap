############################# ENABLE APIS #############################
variable service_apis_to_enable {
  type        = list
  default     = [
    "cloudfunctions.googleapis.com"
  ]
}

resource "google_project_service" "services" {
  for_each                   = toset(var.service_apis_to_enable)
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
}
