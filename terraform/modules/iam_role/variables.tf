variable "project_name" {}
variable "application_name" {}
variable "department" {}
variable "role_name" {}
variable "assume_role_policy" {}
variable "policies" {
  default = []
  description = "A list of policies to attach to the role."
}
variable "tags" {
  type = map(string)
  default = {}
}