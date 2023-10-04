variable "short_environment" { type = string }
variable "default_tags" { type = map(string) }
variable "additional_s3_buckets" {
  type = any
  default = []
}
variable "bucket_name_prefix" { type = string }