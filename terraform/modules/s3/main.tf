resource "aws_s3_bucket" "bucket" {
  bucket = "${var.application_name}-${var.project_name}-${var.bucket_name}"
  force_destroy = true
  policy = var.policy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  versioning {
    enabled = false
  }

  # ACL
  acl = var.acl

  # Grants - Only applied where no canned ACLs are supplied.
  dynamic "grant" {
    for_each = [
      for i in var.grants : {
        id          = i.id
        type        = i.type
        permissions = i.permissions
        uri         = i.uri
      } if(length(var.grants) > 0 && i.enabled == true && var.acl == null)
    ]

    content {
      id          = grant.value.id
      type        = grant.value.type
      permissions = grant.value.permissions
      uri         = grant.value.uri
    }
  }

  tags = merge(
    var.tags,
    {
      Project = var.project_name,
      Application = var.application_name,
      Department = var.department,
    },
  )
}

resource "aws_s3_bucket_public_access_block" "ignition_poc" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "sap_bw" {
  count = var.enable_notification ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = var.trigger.lambda_function_arn
    events              = var.trigger.events
  }
}