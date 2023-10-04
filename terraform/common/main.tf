module "common_s3" {
  source = "./s3"

  short_environment     = var.short_environment
  default_tags          = var.default_tags
  bucket_name_prefix    = var.bucket_name_prefix
  additional_s3_buckets = var.additional_s3_buckets
}

module "vpc" {
  source = "./vpc"

  aws_region        = var.aws_region
  short_environment = var.short_environment
  environment       = var.environment
  short_region      = var.short_region
  default_tags      = var.default_tags

  # VPC
  cidr_etl_network_vpc     = var.cidr_etl_network_vpc
  cidr_etl_network_private = var.cidr_etl_network_private
  cidr_etl_network_public  = var.cidr_etl_network_public
}

module "iam_user" {
  source = "./iam_user"

  aws_account_id    = var.aws_account_id
  aws_region        = var.aws_region
  short_environment = var.short_environment
  short_region      = var.short_region
  default_tags      = var.default_tags
}

module "route53" {
  source   = "./route53"
  for_each = toset([])
  
  aws_region        = var.aws_region
  default_tags      = var.default_tags
  short_environment = var.short_environment
  vpc_ids           = [module.vpc.etl_network_vpc.id]
}
