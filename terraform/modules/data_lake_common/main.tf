# S3
module "s3" {
  source = "./s3"

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
}

# IAM
module "iam" {
  source = "./iam"

  default_tags             = var.default_tags
  lake_tags                = var.lake_tags
  name                     = var.name
  s3_ingestion_bucket_arns = module.s3.s3_ingestion_bucket_arns
  s3_store_bucket_arns     = module.s3.s3_store_bucket_arns
  s3_script_bucket_arns    = var.s3_script_bucket_arns
}

# Catalogue
module "glue" {
  source = "./glue"

  name                      = var.name
  short_environment         = var.short_environment
  functional_zone_ingestion = var.functional_zone_ingestion
  functional_zone_store     = var.functional_zone_store
  role                      = module.iam.lake_formation_role
}
