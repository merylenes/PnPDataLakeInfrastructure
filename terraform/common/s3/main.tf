# Glue schema retrieval Lambda output buckets
module "s3_bucket" {
  source = "../../modules/s3extended"

  bucket = "pnp-data-lake-glue-schema-${var.short_environment}-${var.default_tags.Region}"
  acl    = "private"
}

locals {
  bucket_names = [
    for bucket in var.additional_s3_buckets : replace(lower(format("%s-%s-%s-%s", var.bucket_name_prefix, var.short_environment, bucket.ID, lookup(bucket, "regionOverride", var.default_tags.Region))), "_", "-")
  ]
}

#Additional buckets
module "additional_s3_buckets" {
  count  = length(local.bucket_names)
  source = "../../modules/s3extended"
  bucket = local.bucket_names[count.index]
  acl    = "private"
}
