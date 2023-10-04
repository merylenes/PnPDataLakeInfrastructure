variable "project_name" {}
variable "application_name" {}
variable "department" {}
variable "bucket_name" {}
variable "policy" {
  default = ""
}
variable "enable_notification" {
  default = false
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "trigger" {
  default = {
    lambda_function_arn: "",
    events: []
  }
}

# Optional
variable "acl" {
  description = "The canned ACL to apply."
  type        = string
  default     = null
}

variable "grants" {
  description = "A list of grants that may be optionally applied to the S3 bucket.  Conflicts with ACL."
  type = list(object({
    enabled     = bool
    id          = string
    type        = string
    permissions = list(string)
    uri         = string
  }))

  default = []
}