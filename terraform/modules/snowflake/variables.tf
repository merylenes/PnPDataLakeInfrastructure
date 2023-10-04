variable "snowflake_name" {
  description = "The name that represents this Snowflake setup."
}
variable "buckets" {
  description = "The buckets and their configurations to set on the Snowflake policy."
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
variable "snowflake_canonical_user" {
  description = "The canonical user provided by Snowflake after a connection has been created on Snowflake."
}
variable "snowflake_external_id" {
  description = "The external ID provided by Snowflake after a connection has been created on Snowflake."
}
variable "short_environment" { type = string }
variable "short_region" { type = string }
variable "bucket_name_prefix" { type = string }