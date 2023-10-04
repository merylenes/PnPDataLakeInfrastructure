module "producer_bi" {
  source = "./producer_bi"
  count  = terraform.workspace == "development-eu-west-1" || terraform.workspace == "production-eu-west-1" || terraform.workspace == "qa-eu-west-1" ? 1 : 0

  # Details
  name             = "bi"
  application_name = var.application_name

  s3_script_bucket_arns = [
    "arn:aws:s3:::pnp-data-lake-etl-scripts-euw1",
    format("arn:aws:s3:::pnp-data-lake-%s-etl-scripts-euw1", var.environment_abbreviations[local.environment]),
    format("arn:aws:s3:::pnp-data-lake-%s-etl-emr-workspace-euw1", var.environment_abbreviations[local.environment])
  ]

  # Buckets (Optional, defaults to name).
  functional_zone_ingestion = [
    # TODO:  Move multiple resource creation from using `count` to `for_each`.
    #        The current setup is dependent on the order of these entries.  Removing something in the middle
    #        will result in everything being recreated to match the new perceived order, even though effectively
    #        there are no net changes.

    { ID     = "acz-retail",
      policy = module.acz_retail_s3_bucket_permission.policy.json,
      triggers = [
        {
          lambda_function_arns = module.bootstrap.lambda_functions.trigger_lift_and_shift.arn
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = "bw/td/hrsaw01/processed/"
        }
      ],
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
    { ID     = "acz-pos",
      policy = module.acz_pos_s3_bucket_permission.policy.json,
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
    { ID     = "acz-doc",
      policy = module.acz_doc_s3_bucket_permission.policy.json,
      triggers = [
        {
          // Note: Do we want to add this as a configuration or is this fine? Since this is the same for all workspaces?
          lambda_function_arns = "arn:aws:lambda:eu-west-1:538635328987:function:pnp-data-lake-platform-etl_rec_reports"
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = "bo/rpt/rec_rpt/"
        },
        {
          lambda_function_arns = module.bootstrap.lambda_functions.trigger_lift_and_shift.arn
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = "ih/doc/real_estate_history/"
        }
      ],
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
    { ID = "acz-crm", policy = module.acz_crm_s3_bucket_permission.policy.json
      triggers = [
        {
          lambda_function_arns = module.bootstrap.lambda_functions.trigger_lift_and_shift.arn
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = null
        }
      ],
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
    { ID     = "acz-scl",
      policy = module.acz_scl_s3_bucket_permission.policy.json,
      triggers = [
        {
          // Note: This has been deprecated and should be removed when switched over to the Lambda below
          lambda_function_arns = "arn:aws:lambda:eu-west-1:538635328987:function:pnp-data-lake-platform-pnp_datalake_btb_copy"
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = null
        } /*,
        {
          lambda_function_arns = module.bootstrap.lambda_functions.trigger_lift_and_shift.arn
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = null
        }*/
      ],
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
    { ID     = "acz-finance",
      policy = module.acz_finance_s3_bucket_permission.policy.json,
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
    { ID = "acz-udz",
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
    { ID = "udz-scp",
      triggers = [
        {
          lambda_function_arns = module.bootstrap.lambda_functions.trigger_lift_and_shift.arn
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = null
        }
      ],
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
    { ID = "acz-scp",
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
    { ID = "acz-sys",
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
    { ID = "acz-ols",
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
    { ID = "udz-ols",
      triggers = [
        {
          lambda_function_arns = module.bootstrap.lambda_functions.trigger_lift_and_shift.arn
          events = [
            "s3:ObjectCreated:*"
          ],
          filter_prefix = null
        }
      ],
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
    { ID     = "acz-sud",
      policy = module.acz_sud_s3_bucket_permission.policy.json,
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
    { ID = "acz-cross",
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
    }
    # { ID = "acz-hr" },
    # { ID = "acz-ewm" },
    # { ID = "acz-bpc" },
  ]

  functional_zone_store = [
    { ID     = "stz-retail",
      policy = module.stz_retail_s3_bucket_permission.policy.json
    },
    { ID     = "stz-pos",
      policy = module.stz_pos_s3_bucket_permission.policy.json
    },
    { ID     = "stz-doc",
      policy = module.stz_doc_s3_bucket_permission.policy.json
    },
    { ID = "stz-crm", policy = module.stz_crm_s3_bucket_permission.policy.json },
    { ID = "stz-scl" },
    { ID = "crz-scl" },
    { ID = "stz-finance", policy = module.stz_finance_s3_bucket_permission.policy.json },
    { ID = "stz-datascience" },
    { ID = "crz-scp" },
    { ID = "stz-scp" },
    { ID = "toz-crm" },
    { ID = "stz-sys" },
    { ID = "stz-ols" },
    { ID = "crz-ols" },
    { ID = "stz-sud" },
    { ID = "stz-cross" },
    { ID = "crz-crm" },
    # { ID = "stz-cross" },
    # { ID = "stz-hr" },
    # { ID = "stz-ewm" },
    # { ID = "stz-bpc" },
  ]

  # Use these to set the S3 versioning attribute when the multiple bucket maps aren't being used.
  # s3_versioning_override_store     = true
  # s3_versioning_override_ingestion = true

  # Common
  aws_account_ids_external            = var.aws_account_ids_external
  bucket_name_prefix                  = "pnp-data-lake"
  short_environment                   = var.environment_abbreviations[local.environment]
  short_region                        = var.region_abbreviations[local.region]
  s3_glue_schema_retrieval_bucket_arn = module.common.s3_glue_schema_retrieval_bucket_arn

  # Tags
  ## Lake specific tags (Optional, defaults to {}).
  lake_tags = {
    Lake = "BI"
  }

  ## Default tags
  default_tags = local.default_tags

  snowflake_configuration = var.snowflake_externalConfig.bi

  snowflake = {
    "hub-bi" : {
      "stz-retail" : {
        "read" : [
          "md/*",
          "td/*"        
        ],
        "write" : [],
      },
      "stz-crm" : {
        "read" : [
          "md/*",
          "td/*"  
        ],
        "write" : []
      },
      "stz-pos" : {
        "read" : [
          "td/*"  
        ],
        "write" : [],
      },
      "stz-finance" : {
        "read" : [
          "md/*",
          "td/*"
        ],
        "write" : [],
      },
      "stz-scp" : {
        "read" : [
          "td/*"
        ],
        "write" : [],
      },
      "acz-retail" : {
        "read" : [
          "bw/*",
          "rms*/*",
        ],
        "write" : [
          "sf/md/*",
          "sf/td/*",
        ]
      },
      "acz-pos" : {
        "read" : [],
        "write" : [
          "sf/md/*",
          "sf/td/*",
        ]
      },
    },
    "hub-bi-logistics" : {
      "crz-scl" : {
        "read" : [
          "tpo/*",
          "sdm/*",
          "fmx/*",
          "wmi/*",
          "wmc/*",
          "erp/*",
          "3cx/*",
          "td/*",
          "bw/*"
        ],
        "write" : [],
      },
      "stz-scl" : {
        "read" : [
          "td/*"
        ],
        "write" : [],
      }
    },
    "hub-bi-planning" : {
      "crz-scp" : {
        "read" : [
          "usr/*"
        ],
        "write" : [],
      },
      "stz-scp" : {
        "read" : [
          "td/*"
        ],
        "write" : [],
      },
      "stz-retail" : {
        "read" : [
          "md/*",
          "td/*"
        ],
        "write" : [],
      }
    },
    "hub-bi-datascience" : {
      "stz-datascience" : {
        "read" : [
          "md/*"
        ],
        "write" : [],
      }
    },
    "hub-bi-ols" : {
      "crz-ols" : {
        "read" : [
          "usr/*"
        ],
        "write" : [],
      },
      "stz-ols" : {
        "read" : [
          "md/*",
          "td/*"
          
        ],
        "write" : [],
      }
    },
    "hub-bi-marketing" : {
      "stz-crm" : {
        "read" : [
          "md/*",
          "td/*"
        ],
        "write" : [],
      }
    },
    "hub-bi-assortment-space-planning" : {
      "stz-retail" : {
        "read" : [
          "md/*"

        ],
        "write" : [],
      }
    }
  }

  producer_buckets = {
    "data_services" : [
      "acz-retail",
      "acz-pos",
      "acz-doc",
      "acz-crm",
      "acz-scl",
    ]
    "sap_po" : [
      "acz-scl"
    ]
  }
}

module "stz_retail_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-retail"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_retail
}

module "stz_pos_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-pos"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_pos
}

module "stz_doc_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-doc"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_doc
}

module "acz_retail_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-retail"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_retail
}

module "acz_pos_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-pos"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_pos
}

module "acz_doc_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-doc"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_doc
}

module "acz_crm_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-crm"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_crm
}

module "acz_scl_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-scl"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_scl
}

module "acz_finance_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-finance"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_finance
}

module "stz_finance_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-finance"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_finance
}

module "stz_crm_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-crm"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_crm
}

module "acz_sud_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "acz-sud"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.acz_sud
}

module "stz_cross_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-cross"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_cross
}

module "stz_datascience_s3_bucket_permission" {
  source = "./modules/s3_bucket_policy"

  bucket_name        = "stz-datascience"
  bucket_name_prefix = "pnp-data-lake"
  short_environment  = var.environment_abbreviations[local.environment]
  short_region       = var.region_abbreviations[local.region]
  bucket_permissions = var.buckets_external_config.stz_datascience
}
