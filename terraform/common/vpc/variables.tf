variable "aws_region" { type = string }
variable "short_environment" { type = string }
variable "environment" { type = string }
variable "short_region" { type = string }
variable "default_tags" { type = map(string) }

# VPC
variable "cidr_etl_network_vpc" { type = string }
variable "cidr_etl_network_private" { type = list(string) }
variable "cidr_etl_network_public" { type = list(string) }
