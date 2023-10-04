module "ignition_snowflake_ingest_bucket" {
  source = "../../modules/s3"

  bucket_name = "ignition-snowflake-ingestion"

  application_name = var.application_name
  project_name = var.project_name
  department = var.department

  enable_notification = true
  trigger = {
    lambda_function_arn: "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:pnp-data-lake-platform-pipe_ignition_snowflake_decrypt",
    events: ["s3:ObjectCreated:*"]
  }
}