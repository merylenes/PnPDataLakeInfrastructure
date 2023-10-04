variable "aws_region" { type = string }
variable "short_environment" { type = string }
variable "environment" { type = string }
variable "short_region" { type = string }
variable "default_tags" { type = map(string) }

variable "cidr_etl_network_vpc" { type = string }
variable "cidr_etl_network_private" { type = list(string) }
variable "cidr_etl_network_public" { type = list(string) }

variable "subnet_azs" {
  type    = list(string)
  default = ["a", "b", "c"]
}

# VPC Endpoints
variable "vpc_endpoints_interface" {
  type = list(string)
  default = [
    "ecr.dkr",
    "ecr.api",
  ]
}

variable "vpc_endpoints_gateway" {
  type = list(string)
  default = [
    "s3"
  ]
}

locals {
  vpc_endpoints_interface_list = [
    for endpoint in var.vpc_endpoints_interface :
    "com.amazonaws.${var.aws_region}.${endpoint}"
  ]

  vpc_endpoints_gateway_list = [
    for endpoint in var.vpc_endpoints_gateway :
    "com.amazonaws.${var.aws_region}.${endpoint}"
  ]
}
