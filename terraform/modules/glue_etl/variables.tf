variable "job_name" {
  description = "The name of the ETL job."
}
variable "job_role" {
  description = "The role to assume when the ETL job executes."
}
variable "script_location" {
  description = "The S3 location where the ETL job script is stored."
}
variable "max_capacity" {
  default = 2
  description = "The max capacity of Spark instances to start. (Min 2 instances)."
}
variable "default_arguments" {
  type = map(any)
  default = {}
  description = "Default arguments to set on the ETL job configuration."
}