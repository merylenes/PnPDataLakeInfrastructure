module "ignition_snowflake_ingestion_role" {
  source = "../../modules/iam_role"

  role_name = "ignition-snowflake-ingestion"

  application_name = var.application_name
  project_name = var.project_name
  department = var.department

  assume_role_policy = data.aws_iam_policy_document.ignition_snowflake_ingestion_assume_role_policy
  policies = [data.aws_iam_policy_document.ignition_snowflake_policy]
}

data "aws_iam_policy_document" "ignition_snowflake_ingestion_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    sid = ""

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::080031022953:user/externalstages/bjzziqdiaoshftstgwfb"]
    }

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"

      values = [
        "PM58521_SFCRole=2_lsXBoN8TMmo3hw2wKl8HV7w9NcU=",
      ]
    }
  }
}

data "aws_iam_policy_document" "ignition_snowflake_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:ListBucket"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.s3_buckets.ignition_snowflake_ingestion.bucket}/*",
      "arn:aws:s3:::${var.s3_buckets.ignition_snowflake_ingestion.bucket}",
    ]
  }
}