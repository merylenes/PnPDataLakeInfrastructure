variable "aws_account_ids_external" { type = map(string) }
variable "bucket_name_prefix" { type = string }

variable "default_tags" {
  description = "Tags applied to all resources."
  type        = map(string)
}

variable "name" {
  description = "Refers to the lake, or project name.  Ex. 'sap_bw'."
  type        = string
}
variable "application_name" {}

variable "short_environment" { type = string }
variable "short_region" { type = string }

variable "functional_zone_ingestion" {
  description = <<-EOF
    A list of maps, each defining the buckets to be created.  
    Supports two keys:  
      ID (mandatory) = the bucket zone and functional area, separated by a dash; 
      versioning (optional, defaults to false) = determines whether versioning should be enabled.
      lifecycle_rules (optional, module contains default) = list of lifecycle rules.  Disable by sending in an empty list.
  EOF
  type        = any
  default     = []
}

variable "functional_zone_store" {
  description = <<-EOF
    A list of maps, each defining the buckets to be created.  
    Supports two keys:  
      ID (mandatory) = the bucket zone and functional area, separated by a dash; 
      versioning (optional, defaults to false) = determines whether versioning should be enabled.
  EOF
  default     = []
}

variable "lake_tags" {
  description = "Lake specific tags, ex. 'Lake = sap_bw'."
  type        = map(string)
  default     = {}
}

variable "s3_glue_schema_retrieval_bucket_arn" {
  description = "ARN of the bucket used to output the Glue database schemas."
  type        = string
}

variable "s3_versioning_override_store" {
  type    = bool
  default = false
}

variable "s3_versioning_override_ingestion" {
  type    = bool
  default = false
}

variable "snowflake" {
  description = "Configurations used for the Snowflake integration."
}
variable "snowflake_configuration" {
  description = "The canonical user provided by Snowflake after a connection has been created on Snowflake."
}

variable "producer_buckets" {
  description = "A list of producers in the consumer with a list of buckets the producer must have access to."
}

variable "s3_script_bucket_arns" {
  default = []
  type = list(string)
}
