# Complete bucket example:
#   https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/blob/master/examples/complete/main.tf

locals {
  # Bucket names  
  #   Replace any underscores with dashes to comply with naming convention, convert to lowercase.
  #   Naming convention:  
  #     Default                                   = <Prefix> - <Short Environment> - <Data Lake Name> - <Bucket purpose> - <Short Region>
  #     If zone/function designations are present = <Prefix> - <Short Environment> - <Zone + Functional Area>            - <Short Region>
  s3_ingestion_bucket_names = length(var.functional_zone_ingestion) > 0 ? formatlist(replace(lower("${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), "_", "-"), var.functional_zone_ingestion.*.ID) : list(lower(replace("${var.bucket_name_prefix}-${var.short_environment}-${var.name}-ingestion-${var.short_region}", "_", "-")))
}

# Ingestion bucket policy - Write access for Decision Support account.
data "aws_iam_policy_document" "s3_ingestion_bucket_policy" {
  count = length(local.s3_ingestion_bucket_names)

  statement {
    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_ids_external.decision_support}:root"]
    }

    resources = [
      "arn:aws:s3:::${local.s3_ingestion_bucket_names[count.index]}",
      "arn:aws:s3:::${local.s3_ingestion_bucket_names[count.index]}/*",
    ]
  }
}

# Ingestion bucket
locals {
  s3_ingestion_default_lifecycle_rule = [
    {
      id      = "all_objects_intelligent_tiering_after_90_days"
      enabled = true
      prefix = null
      abort_incomplete_multipart_upload_days = null
      expiration = {}

      transition = [
        {
          days          = 90
          storage_class = "INTELLIGENT_TIERING"
        }
      ]
    },
  ]
}

module "s3_ingestion" {
  count  = length(local.s3_ingestion_bucket_names)
  source = "../../s3extended"

  # General
  bucket = local.s3_ingestion_bucket_names[count.index]

  # Triggers
  triggers = length(var.functional_zone_ingestion) > 0 ? (contains(keys(var.functional_zone_ingestion[count.index]), "triggers") ? var.functional_zone_ingestion[count.index].triggers : []) : []

  # Resource policy
  attach_policy = contains(keys(var.functional_zone_ingestion[count.index]), "policy")
  policy        = length(var.functional_zone_ingestion) > 0 ? contains(keys(var.functional_zone_ingestion[count.index]), "policy") ? replace(var.functional_zone_ingestion[count.index].policy, var.functional_zone_ingestion[count.index].ID, local.s3_ingestion_bucket_names[count.index]) : null : null


  # Versioning
  versioning = {
    # Fall back to `false` if not explicitly defined in the input map, or where the map itself is absent.
    enabled = length(var.functional_zone_ingestion) > 0 ? (contains(keys(var.functional_zone_ingestion[count.index]), "versioning") ? var.functional_zone_ingestion[count.index].versioning : false) : var.s3_versioning_override_ingestion
  }

  # Lifecycle Rules
  lifecycle_rule = length(var.functional_zone_ingestion) > 0 ? contains(keys(var.functional_zone_ingestion[count.index]), "lifecycle_rules") ? var.functional_zone_ingestion[count.index].lifecycle_rules : [] : []

  # Logging
  logging = {
    target_bucket = module.s3_logging.this_s3_bucket_id
    target_prefix = "${local.s3_ingestion_bucket_names[count.index]}/"
  }

  # Tags
  tags = merge(
    var.default_tags,
    var.default_s3_tags,
    var.lake_tags,
    {
      Name = local.s3_ingestion_bucket_names[count.index]
    }
  )
}
