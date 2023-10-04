output "s3_ingestion_bucket_arns" { value = module.s3_ingestion.*.this_s3_bucket_arn }
output "s3_store_bucket_arns" { value = module.s3_store.*.this_s3_bucket_arn }
