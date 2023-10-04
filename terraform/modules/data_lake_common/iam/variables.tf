# Mandatory
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

variable "s3_ingestion_bucket_arns" { type = list(string) }
variable "s3_store_bucket_arns" { type = list(string) }
variable "s3_script_bucket_arns" {
  default = []
  type = list(string)
}

# Optional
variable "default_iam_tags" {
  type = map(string)
  default = {
    Service = "IAM"
    Role    = "Authorization"
  }
}
