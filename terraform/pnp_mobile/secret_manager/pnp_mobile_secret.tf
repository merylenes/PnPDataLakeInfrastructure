module "pnp_mobile_secret" {
  source = "../../modules/secret_manager_secret"

  secret_name = "secrets"

  application_name = var.application_name
  department = var.department
  project_name = var.project_name
}