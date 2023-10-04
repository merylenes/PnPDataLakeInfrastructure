variable "redshift_name" {
  description = "The name that represents this Redshift setup."
}
variable "buckets" {
  description = "The buckets and their configurations to set on the Redshift policy."
}
variable "application_name" {
  description = "The application name."
}
variable "project_name" {
  description = "The project name."
}
variable "lake_tags" {
  description = "A list of tags to add on resources managed by this module."
}
variable "redshift_account_arn" {
  description = "The AWS account ARN where the Redshift cluster runs."
}
variable "short_environment" { type = string }
variable "short_region" { type = string }
variable "bucket_name_prefix" { type = string }