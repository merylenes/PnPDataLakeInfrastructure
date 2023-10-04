variable "aws_profile" {}
variable "aws_assume_role_arn" {}
variable "aws_region" {}
variable "application_name" {}
variable "snowflake_externalConfig" {}
variable "redshift_external_config" {}
variable "aws_account_ids_external" {
  type = map(string)
}
variable "buckets_external_config" {}
variable "buckets_external_config_boxer" {}
variable "buckets_ingestion_retention_days" {
  description = "Retention period in days for the ingestion S3 buckets."
}

locals {
  # Workspace convention: <ENVIRONMENT>-<REGION>, ex "development-eu-west-1"
  environment = split("-", terraform.workspace)[0]
  region      = split("${local.environment}-", terraform.workspace)[1]
}

variable "environment_abbreviations" {
  type        = map(string)
  description = "Used with local.environment to look up the abbreviated form of the workspace, ie. environment."
  default = {
    "development" = "dev"
    "testing"     = "test"
    "staging"     = "stag"
    "production"  = "prod"
    "sandbox"     = "sbx"
    "qa"          = "qa"
  }
}

variable "region_abbreviations" {
  type        = map(string)
  description = "Used with local.region to look up the region's abbreviated form."
  default = {
    "af-south-1"     = "afs1",
    "ap-east-1"      = "ape1",
    "ap-northeast-1" = "apne1",
    "ap-northeast-2" = "apne2",
    "ap-northeast-3" = "apne3",
    "ap-south-1"     = "aps1",
    "ap-southeast-1" = "apse1",
    "ap-southeast-2" = "aps2e",
    "ca-central-1"   = "cac1",
    "cn-north-1"     = "cnn1",
    "cn-northwest-1" = "cnnw1",
    "eu-central-1"   = "euc1",
    "eu-north-1"     = "eun1",
    "eu-south-1"     = "eus1",
    "eu-west-1"      = "euw1",
    "eu-west-2"      = "euw2",
    "eu-west-3"      = "euw3",
    "me-south-1"     = "mes1",
    "sa-east-1"      = "sae1",
    "us-east-1"      = "use1",
    "us-east-2"      = "use2",
    "us-west-1"      = "usw1",
    "us-west-2"      = "usw2",
  }
}

locals {
  default_tags = {
    Application = var.application_name
    Department  = "BI"
    Region      = var.aws_region
    ManagedWith = "Terraform"
    ManagedBy   = "20fifty"
  }
}

variable "cidr_etl_network_vpc" {
  type = string
}

variable "cidr_etl_network_private" {
  type = list(string)
}

variable "cidr_etl_network_public" {
  type = list(string)
}
