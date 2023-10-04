/*
  S3 Server Access Logging
  Reference:  https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html
*/

module "s3_logging" {
  source = "../../s3extended"

  # General
  bucket = "${var.bucket_name_prefix}-logging-${var.short_environment}-${var.short_region}"

  # Lifecycle Rules
  lifecycle_rule = var.s3_access_logging_lifecycle

  # ACL - Required for enabling logging
  acl = "log-delivery-write"

  # Tags
  tags = merge(
    var.default_tags,
    var.default_s3_tags,
    var.lake_tags,
    {
      Name = "${var.bucket_name_prefix}-logging-${var.short_environment}-${var.short_region}"
    }
  )
}
