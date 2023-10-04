variable "project_name" {}
variable "application_name" {}
variable "department" {}
variable "aws_region" {}
variable "aws_account_id" {}
variable "aws_account_ids_external" {
  type = map(string)
}