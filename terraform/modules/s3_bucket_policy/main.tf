data "aws_iam_policy_document" "s3_stz_doc_bucket_policy" {

  dynamic "statement" {
    for_each = var.bucket_permissions

    content {
      sid = "${statement.key}Actions"
      actions = statement.value.actions

      principals {
        type        = "AWS"
        identifiers = statement.value.principal_identifiers
      }

      effect = "Allow"
      resources = [for path in statement.value.data_sets: "arn:aws:s3:::${var.bucket_name}/${path}"]
    }
  }


  dynamic "statement" {
    for_each = var.bucket_permissions

    content {
      sid = "${statement.key}ListBucket"
      actions = [
        "s3:ListBucket",
      ]

      principals {
        type        = "AWS"
        identifiers = statement.value.principal_identifiers
      }

      condition {
        test     = "StringLike"
        variable = "s3:prefix"

        values = statement.value.data_sets
      }

      resources = [
        "arn:aws:s3:::${var.bucket_name}"
      ]
    }
  }
}