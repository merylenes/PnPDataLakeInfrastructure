# Complete bucket example:
#   https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/blob/master/examples/complete/main.tf

locals {
  # Bucket names  
  #   Replace any underscores with dashes to comply with naming convention, convert to lowercase.
  #   Naming convention:  
  #     Default                                   = <Prefix> - <Short Environment> - <Data Lake Name> - <Bucket purpose> - <Short Region>
  #     If zone/function designations are present = <Prefix> - <Short Environment> - <Zone + Functional Area>            - <Short Region>
  s3_store_bucket_names = length(var.functional_zone_store) > 0 ? formatlist(replace(lower("${var.bucket_name_prefix}-${var.short_environment}-%s-${var.short_region}"), "_", "-"), var.functional_zone_store.*.ID) : list(lower(replace("${var.bucket_name_prefix}-${var.short_environment}-${var.name}-store-${var.short_region}", "_", "-")))
}

# Store bucket(s)
module "s3_store" {
  count  = length(local.s3_store_bucket_names)
  source = "../../s3extended"

  # General
  bucket = local.s3_store_bucket_names[count.index]

  # Resource policy
  ## NOTE:  Attaching a resource policy is not necessary, since Lake Formation will be used to set up cross account sharing.  In fact, adding a policy here interferes with the sharing.
  attach_policy = contains(keys(var.functional_zone_store[count.index]), "policy")
  policy = length(var.functional_zone_store) > 0 ? contains(keys(var.functional_zone_store[count.index]), "policy") ? replace(var.functional_zone_store[count.index].policy, var.functional_zone_store[count.index].ID, local.s3_store_bucket_names[count.index]) : null : null

  # Versioning
  versioning = {
    # Fall back to `false` if not explicitly defined in the input map, or where the map itself is absent.
    enabled = length(var.functional_zone_store) > 0 ? (contains(keys(var.functional_zone_store[count.index]), "versioning") ? var.functional_zone_store[count.index].versioning : false) : var.s3_versioning_override_store
  }

    # Logging
  logging = {
    target_bucket = module.s3_logging.this_s3_bucket_id
    target_prefix = "${local.s3_store_bucket_names[count.index]}/"
  }

  # Tags
  tags = merge(
    var.default_tags,
    var.default_s3_tags,
    var.lake_tags,
    {
      Name = local.s3_store_bucket_names[count.index]
    }
  )

  /*lifecycle_rule = [
    {
      enabled: true,
      abort_incomplete_multipart_upload_days = 1,
      expiration: {
        expired_object_delete_marker: true,
      }
    }
  ]*/
}
