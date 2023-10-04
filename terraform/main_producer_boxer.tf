module "producer_boxer" {
  source   = "./producer_boxer"
  for_each = toset([terraform.workspace])

  # Details
  name             = "box"
  application_name = "box-data-lake"

  # Common
  aws_account_ids_external            = var.aws_account_ids_external
  bucket_name_prefix                  = "box-data-lake"
  short_environment                   = var.environment_abbreviations[local.environment]
  short_region                        = var.region_abbreviations[local.region]
  s3_glue_schema_retrieval_bucket_arn = module.common.s3_glue_schema_retrieval_bucket_arn

  s3_script_bucket_arns = [
    "arn:aws:s3:::pnp-data-lake-etl-scripts-euw1",
    format("arn:aws:s3:::pnp-data-lake-%s-etl-scripts-euw1", var.environment_abbreviations[local.environment]),
    format("arn:aws:s3:::pnp-data-lake-%s-etl-emr-workspace-euw1", var.environment_abbreviations[local.environment])
  ]
  producer_buckets = {}

  functional_zone_ingestion = [
    { ID     = "acz-retail",
      policy = module.boxer_acz_retail_s3_bucket_permission.policy.json,
      lifecycle_rules = [
        {
          id                                     = "default_retention_period"
          enabled                                = true
          abort_incomplete_multipart_upload_days = 1
          expiration = {
            days                         = var.buckets_ingestion_retention_days.default
            expired_object_delete_marker = false
          }
        }
      ]
    },
  ]

  functional_zone_store = [
    { ID     = "stz-retail",
      policy = module.boxer_stz_retail_s3_bucket_permission.policy.json
    },
  ]

  # Tags
  ## Lake specific tags (Optional, defaults to {}).
  lake_tags = {
    Lake = "Boxer"
  }

  ## Default tags
  default_tags = merge(
    local.default_tags,
    {
      Application = "boxer-data-lake"
      Department  = "Boxer"
    }
  )
  snowflake_configuration = var.snowflake_externalConfig.box
  snowflake = {
    "hub-box" : {
      "stz-retail" : {
        "read" : [
          "md/article/article_box_article_01*/*",
          "md/article/article_box_articlebarcode_01*/*",
          "td/sales/sales_box_sales_01*/*",
          "td/sales/sales_box_salesplan_01*/*",
          "md/site/site_box_site_01*/*",
        ],
        "write" : [],
      },
    }
  }
}



module "boxer_acz_retail_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-retail"
  bucket_name_prefix = "boxer-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config_boxer.acz_retail
}

module "boxer_stz_retail_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-retail"
  bucket_name_prefix = "boxer-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config_boxer.stz_retail
}
