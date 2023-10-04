
module "redshift_role" {
  source = "../iam_role"

  role_name = "${var.redshift_name}-${var.short_environment}"

  application_name = var.application_name
  project_name = var.project_name
  department = var.project_name
  tags = var.lake_tags

  assume_role_policy = data.aws_iam_policy_document.redshift_assume_role_policy
  policies = [data.aws_iam_policy_document.redshift_policy]
}

data "aws_iam_policy_document" "redshift_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.redshift_account_arn]
    }
  }
}

data "aws_iam_policy_document" "redshift_policy" {

  dynamic "statement" {
    for_each = var.buckets

    content {
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      effect = "Allow"
      resources = [for path in statement.value: "arn:aws:s3:::${replace(format(lower("${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), statement.key), "_", "-")}/${path}"]
    }
  }

  dynamic "statement" {
    for_each = var.buckets

    content {
      actions = [
        "s3:ListBucket",
      ]

      resources = [
        replace(format(lower("%s${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}/*"), "arn:aws:s3:::", statement.key), "_", "-"),
        replace(format(lower("%s${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), "arn:aws:s3:::", statement.key), "_", "-"),
        ]
    }
  }
}