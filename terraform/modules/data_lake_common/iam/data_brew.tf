locals {
  # Role name.  Replace any underscores with dashes to comply with naming convention.
  # Naming convention:  <AWS Service Name>-<Database Name>-<Environment>
  iam_role_data_brew = lower(replace("data-brew-${var.name}-${split("-", terraform.workspace)[0]}", "_", "-"))
}

data "aws_iam_policy_document" "data_brew_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "databrew.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "data_brew_s3_access" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = formatlist("%s/*", var.s3_ingestion_bucket_arns)
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = formatlist("%s/*", var.s3_store_bucket_arns)
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = concat(var.s3_ingestion_bucket_arns, var.s3_store_bucket_arns)
  }

  statement {
    actions = [
      "s3:PutObjectAcl"
    ]

    resources = formatlist("%s/*", var.s3_store_bucket_arns)

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

  }
}

resource "aws_iam_role" "data_brew" {
  name               = local.iam_role_data_brew
  description        = "Role used by Lake formation and Glue to access data stored in S3."
  assume_role_policy = data.aws_iam_policy_document.data_brew_assume_role_policy.json

  # Tags
  tags = merge(
    var.default_tags,
    var.default_iam_tags,
    var.lake_tags,
    {
      Name = local.iam_role_data_brew
    }
  )
}

resource "aws_iam_role_policy" "data_brew_s3_access" {
  name   = local.iam_role_data_brew
  policy = data.aws_iam_policy_document.data_brew_s3_access.json
  role   = aws_iam_role.data_brew.id
}

resource "aws_iam_role_policy_attachment" "AWSGlueDataBrewServiceRole" {
  role       = aws_iam_role.data_brew.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueDataBrewServiceRole"
}
