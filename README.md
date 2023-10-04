# PnP Data Lake Infrastructure

A Terraform project managing all data lake resources.  

# Modules

## pnp_mobile

```yaml
Name:         pnp_mobile
Source:       terraform/pnp_mobile/
Description:  Used to manage the PnP mobile project's infrastructure.
```

`Note`:  This module hasn't been (and can't) be refactored to use the newer `data_lake` module, since it contains resources (S3 buckets) that are already used in production and cannot be recreated.

# Adding new lakes

Create a separate module for each lake:

The `functional_zone_store` and `functional_zone_ingestion` , maps are used to determine which buckets should be created.

When present, the bucket naming convention will be:
  `<Prefix>-<Short Environment>-<Zone + Functional Area>-<Short Region>`

In their absence, it becomes:
  `<Prefix>-<Short Environment>-<Data Lake Name>-<Bucket purpose>-<Short Region>`

The `versioning` keys in those maps are also optional.  When left out, the value defaults to `false`.

```bash
module "<LAKE_NAME>" {
  source = "./<LAKE_NAME>"
  count  = terraform.workspace == "development-eu-west-1" || terraform.workspace == "production-eu-west-1" ? 1 : 0

  # Details
  name = "<LAKE_NAME>"

  # Buckets (Optional, defaults to name).
  functional_zone_ingestion = [
    {
      ID              = "acz-retail",
      versioning      = false
      lifecycle_rules = [
        {
          id      = "all_objects_intelligent_tiering_after_45_days"
          enabled = true
     
          transition = [
            {
              days          = 45
              storage_class = "INTELLIGENT_TIERING"
            }
          ]
        },
      ]
      # Or, to explicitly disable: 
      #   lifecycle_rules = [].  
      # Otherwise, a default (transition to Intelligent Tiering after 90 days) will be applied.
    }
  ]

  functional_zone_store = [
    {
      ID         = "stz-retail",
      versioning = false            # These are optional, will default to false if left out.
    },
    { ID         = "stz-finance",
      versioning = true
    }
  ]

  # Use these to set the S3 versioning attribute when the multiple bucket maps aren't being used.
  # s3_versioning_override_store     = true
  # s3_versioning_override_ingestion = true

  # Common
  aws_account_ids_external = var.aws_account_ids_external
  bucket_name_prefix       = "pnp-data-lake"
  short_environment        = var.environment_abbreviations[local.environment]
  short_region             = var.region_abbreviations[local.region]

  # Tags
  ## Lake specific tags (Optional, defaults to {}).
  lake_tags = {
    Lake = "<LAKE_NAME>"
  }

  ## Default tags
  default_tags = {
    Application = var.application_name
    Department  = "BW"
    Region      = var.aws_region
  }
}
```

The `<LAKE_NAME>` module should then call the `modules/data_lake_common` sub-module that handles the creation of all common resources (S3 ingestion and store buckets, IAM roles for Lake formation and Data Brew).

```bash
# Common resources
module "common" {
  source = "../modules/data_lake_common"

  aws_account_ids_external           = var.aws_account_ids_external
  bucket_name_prefix                 = var.bucket_name_prefix
  default_tags                       = var.default_tags
  functional_zone_ingestion          = var.functional_zone_ingestion
  functional_zone_store              = var.functional_zone_store
  lake_tags                          = var.lake_tags
  name                               = var.name
  short_environment                  = var.short_environment
  short_region                       = var.short_region
}
```

## Tagging

Projects, lakes and services can all be tagged independently:
* Project tags are defined in the `default_tags` map in the module call.
* Lake tags can be specified in the `lake_tags` map.
* Service tags (tags set accross say all S3, or all IAM resources) can be set in the `modules/data_lake_common/<SERVICE>/variables.tf` / `default_<SERVICE>_tags` variables.
