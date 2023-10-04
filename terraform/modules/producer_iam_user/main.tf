resource "aws_iam_user" "producer" {
  name = "${var.producer_name}-${var.short_environment}-${var.short_region}"
  tags = var.tags
}

resource "aws_iam_user_policy" "producer" {
  name = "${var.producer_name}-${var.short_environment}-${var.short_region}"
  user = aws_iam_user.producer.name

  policy = data.aws_iam_policy_document.producer.json
}

data "aws_iam_policy_document" "producer" {

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:GetBucketAcl"
    ]
    effect = "Allow"

    resources = [for s in var.buckets : replace(format(lower("%s${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}/*"), "arn:aws:s3:::", s), "_", "-")]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [for s in var.buckets : replace(format(lower("%s${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), "arn:aws:s3:::", s), "_", "-")]
  }
}