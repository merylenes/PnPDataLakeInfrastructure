# Common resources
module "common" {
  source = "../modules/data_lake_common"

  aws_account_ids_external         = var.aws_account_ids_external
  bucket_name_prefix               = var.bucket_name_prefix
  default_tags                     = var.default_tags
  functional_zone_ingestion        = var.functional_zone_ingestion
  functional_zone_store            = var.functional_zone_store
  lake_tags                        = var.lake_tags
  name                             = var.name
  s3_versioning_override_ingestion = var.s3_versioning_override_ingestion
  s3_versioning_override_store     = var.s3_versioning_override_store
  short_environment                = var.short_environment
  short_region                     = var.short_region
  s3_script_bucket_arns            = var.s3_script_bucket_arns
}

module "producer_iam_user" {

  for_each = var.producer_buckets

  source = "../modules/producer_iam_user"

  bucket_name_prefix = "pnp-data-lake"

  producer_name = each.key
  short_environment = var.short_environment
  short_region = var.short_region

  tags = merge(
    var.default_tags,
    var.lake_tags,
  )

  buckets = each.value
}
