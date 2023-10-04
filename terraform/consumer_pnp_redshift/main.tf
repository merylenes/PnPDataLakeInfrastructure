module "pnp_redshift" {
  source = "../modules/redshift"

  for_each = var.redshift

  redshift_name = each.key

  application_name = var.application_name
  lake_tags = var.lake_tags
  project_name = var.project_name
  short_environment        = var.short_environment
  short_region = var.short_region
  bucket_name_prefix = var.bucket_name_prefix

  redshift_account_arn = var.redshift_account_arn

  buckets = each.value
}