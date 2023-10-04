locals {
  # Role name.  Replace any underscores with dashes to comply with naming convention.
  # Naming convention:  <AWS Service Name>-<Database Name>-<Environment>
  iam_role_lake_formation_glue = lower(replace("lake-formation-${var.name}-${split("-", terraform.workspace)[0]}", "_", "-"))
}

data "aws_iam_policy_document" "lake_formation_glue_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lakeformation.amazonaws.com",
        "glue.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lake_formation_glue_s3_access" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = formatlist("%s/*", concat(var.s3_ingestion_bucket_arns, var.s3_store_bucket_arns, var.s3_script_bucket_arns))
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = concat(var.s3_ingestion_bucket_arns, var.s3_script_bucket_arns)
  }

  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    actions   = ["lakeformation:GetDataAccess"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "lake_formation_glue" {
  name               = local.iam_role_lake_formation_glue
  description        = "Role used by Lake formation and Glue to access data stored in S3."
  assume_role_policy = data.aws_iam_policy_document.lake_formation_glue_assume_role_policy.json

  # Tags
  tags = merge(
    var.default_tags,
    var.default_iam_tags,
    var.lake_tags,
    {
      Name = local.iam_role_lake_formation_glue
    }
  )

  lifecycle {
    ignore_changes = [assume_role_policy]
  }
}

resource "aws_iam_role_policy" "lake_formation_glue_s3_access" {
  name   = local.iam_role_lake_formation_glue
  policy = data.aws_iam_policy_document.lake_formation_glue_s3_access.json
  role   = aws_iam_role.lake_formation_glue.id
}

resource "aws_iam_role_policy_attachment" "AWSGlueServiceRole" {
  role       = aws_iam_role.lake_formation_glue.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
