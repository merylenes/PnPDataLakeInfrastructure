resource "aws_glue_job" "etl_job" {
  name     = var.job_name
  role_arn = var.job_role.arn
  glue_version = "2.0"
  max_capacity = var.max_capacity

  command {
    script_location = var.script_location
  }

  default_arguments = var.default_arguments
}