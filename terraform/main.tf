terraform {
  backend "s3" {
    key                  = "data-lake"
    encrypt              = true
    bucket               = "20fifty-devops-terraform-state"
    region               = "eu-west-1"
    profile              = "default"
    workspace_key_prefix = "pnp"
  }
}

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.aws_profile

  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}

data "aws_caller_identity" "current_identity" {}

locals {
  departments = {
    bi : "bi"
  }
}

module "bootstrap" {
  source      = "./bootstrap"
  environment = var.environment_abbreviations[local.environment]
}

# PNP Mobile
module "pnp_mobile" {
  source = "./pnp_mobile"
  count  = terraform.workspace == "production-eu-west-1" ? 1 : 0

  project_name = "pnp-mobile"

  application_name         = var.application_name
  department               = local.departments.bi
  aws_account_id           = data.aws_caller_identity.current_identity.account_id
  aws_region               = var.aws_region
  aws_account_ids_external = var.aws_account_ids_external
}

# Common Data Lake Infrastructure
module "common" {
  source = "./common"

  aws_region         = var.aws_region
  aws_account_id     = data.aws_caller_identity.current_identity.account_id
  short_environment  = var.environment_abbreviations[local.environment]
  environment        = local.environment
  short_region       = var.region_abbreviations[local.region]
  default_tags       = local.default_tags
  bucket_name_prefix = "pnp-data-lake"

  additional_s3_buckets = [
    {
      ID = "odbc-query-results",
    },
    {
      ID             = "etl-scripts",
      regionOverride = var.region_abbreviations[local.region]
    },
    {
      ID             = "etl-emr-workspace",
      regionOverride = var.region_abbreviations[local.region]
    }
  ]

  # VPC
  cidr_etl_network_vpc     = var.cidr_etl_network_vpc
  cidr_etl_network_private = var.cidr_etl_network_private
  cidr_etl_network_public  = var.cidr_etl_network_public
}
