module "s3" {
  source = "./s3"

  application_name = var.application_name
  department = var.department
  project_name = var.project_name
  aws_account_id = var.aws_account_id
  aws_region = var.aws_region
  aws_account_ids_external = var.aws_account_ids_external
}

module "iam" {
  source = "./iam"

  s3_buckets = module.s3.buckets

  application_name = var.application_name
  department = var.department
  project_name = var.project_name
}

module "secret_manager" {
  source = "./secret_manager"

  application_name = var.application_name
  department = var.department
  project_name = var.project_name
}