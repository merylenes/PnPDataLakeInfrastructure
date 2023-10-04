variable "project_name" {}
variable "application_name" {}
variable "department" {}
variable "secret_name" {}
variable "tags" {
  type = map(string)
  default = {}
}