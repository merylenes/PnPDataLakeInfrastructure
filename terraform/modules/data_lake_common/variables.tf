# Mandatory
variable "aws_account_ids_external" { type = map(string) }
variable "bucket_name_prefix" { type = string }

variable "default_tags" {
  description = "Tags applied to all resources."
  type        = map(string)
}

variable "functional_zone_ingestion" {
  description = <<-EOF
    A list of maps, each defining the buckets to be created.  
    Supports two keys:  
      ID (mandatory) = the bucket zone and functional area, separated by a dash; 
      versioning (optional, defaults to false) = determines whether versioning should be enabled.
      lifecycle_rules (optional, module contains default) = list of lifecycle rules.  Disable by sending in an empty list.
  EOF
  type        = any
}

variable "functional_zone_store" {
  description = <<-EOF
    A list of maps, each defining the buckets to be created.  
    Supports two keys:  
      ID (mandatory) = the bucket zone and functional area, separated by a dash; 
      versioning (optional, defaults to false) = determines whether versioning should be enabled.
  EOF
}

variable "lake_tags" {
  description = "Lake specific tags, ex. 'Lake = sap_bw'."
  type        = map(string)
}

variable "name" {
  description = "Refers to the lake, or project name.  Ex. 'sap_bw'."
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

variable "short_environment" { type = string }
variable "short_region" { type = string }
variable "s3_script_bucket_arns" {
  default = []
  type = list(string)
}
