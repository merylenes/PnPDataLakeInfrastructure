module "snowflake" {
  source = "../modules/snowflake/"

  for_each = var.snowflake

  snowflake_name = each.key

  application_name = var.application_name
  lake_tags = var.lake_tags
  project_name = var.name
  short_environment        = var.short_environment
  short_region = var.short_region
  bucket_name_prefix = var.bucket_name_prefix

  snowflake_canonical_user = var.snowflake_configuration[each.key].snowflake_canonical_user
  snowflake_external_id = var.snowflake_configuration[each.key].snowflake_external_id

  buckets = each.value
}

# S3 - Glue Schema Retrieval Bucket Access
data "aws_iam_policy_document" "s3_glue_schema_retrieval" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      var.s3_glue_schema_retrieval_bucket_arn,
      "${var.s3_glue_schema_retrieval_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "snowflake_s3_glue_schema_retrieval" {
  for_each = toset(["hub-box"])
  
  name   = "s3_glue_schema_retrieval_${var.short_environment}_${var.short_region}"
  policy = data.aws_iam_policy_document.s3_glue_schema_retrieval.json
  role   = module.snowflake[each.key].aws_iam_role.name
}
