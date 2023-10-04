output "buckets" {
  value = {
    ignition_snowflake_ingestion: module.ignition_snowflake_ingest_bucket.bucket,
  }
}