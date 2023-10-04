/*
  This module is responsible to setup the integration required for a Snowflake database instance to utilise AWS resources.

  Currently this module only supports get object access, but can be extended to allow put object access in the cases where Snowflake
  has to export data to an S3 bucket.

  The module will create one role and attach one policy to the role. The policy can support multiple statements for multiple
  S3 buckets and to configure their permissions separately.

  For each bucket added a statement will be generated with the required get permissions and a statement for list permissions.
  The list statement will limit the prefix to the S3 path specified.

  Snowflake documentation: https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html
*/

locals {
  read_paths = flatten([
    for bucket, configuration in var.buckets : [
      for path in configuration.read :
        "arn:aws:s3:::${replace(format(lower("${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), bucket), "_", "-")}/${path}"
    ]
  ])
  write_paths = flatten([
    for bucket, configuration in var.buckets : [
      for path in configuration.write :
        "arn:aws:s3:::${replace(format(lower("${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), bucket), "_", "-")}/${path}"
      ]
  ])
  buckets = [
    for bucket , configuration in var.buckets :
      "arn:aws:s3:::${replace(format(lower("${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), bucket), "_", "-")}"
  ]
}

module "snowflake_role" {
  source = "../iam_role"

  role_name = "snowflake-${var.snowflake_name}-${var.short_environment}"

  application_name = var.application_name
  project_name = var.project_name
  department = var.project_name
  tags = var.lake_tags

  assume_role_policy = data.aws_iam_policy_document.snowflake_assume_role_policy
  policies = flatten([data.aws_iam_policy_document.snowflake_write_policy[*], data.aws_iam_policy_document.snowflake_policy[*]])
}

data "aws_iam_policy_document" "snowflake_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.snowflake_canonical_user]
    }

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"

      values = [
        var.snowflake_external_id,
      ]
    }
  }
}

data "aws_iam_policy_document" "snowflake_policy" {

  count = length(local.read_paths) > 0 ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = local.buckets
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = local.read_paths
  }
}

data "aws_iam_policy_document" "snowflake_write_policy" {
  count = length(local.write_paths) > 0 ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = local.write_paths
  }
}
