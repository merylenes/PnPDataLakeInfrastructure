# Mandatory
variable "aws_account_ids_external" { type = map(string) }
variable "bucket_name_prefix" { type = string }

variable "default_tags" {
  description = "Tags applied to all resources."
  type        = map(string)
}

variable "lake_tags" {
  description = "Lake specific tags, ex. 'Lake = sap_bw'."
  type        = map(string)
}

variable "name" {
  description = "Refers to the lake, or project name.  Ex. 'sap_bw'."
  type        = string
}

variable "short_environment" { type = string }
variable "short_region" { type = string }

# Optional
variable "default_s3_tags" {
  type = map(string)
  default = {
    Service = "S3"
    Role    = "Storage"
  }
}

variable "functional_zone_ingestion" {
  type    = any
  default = []
}

variable "functional_zone_store" {
  default = []
}

variable "s3_versioning_override_store" { type = bool }
variable "s3_versioning_override_ingestion" { type = bool }

variable "s3_access_logging_lifecycle" {
  type = list(any)
  
  default = [
    {
      id      = "log"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
          }, {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
    },
  ]
}
