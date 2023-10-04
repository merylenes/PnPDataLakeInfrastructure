module "etl_network" {
  source = "./etl_network"

  aws_region        = var.aws_region
  short_environment = var.short_environment
  environment       = var.environment
  short_region      = var.short_region
  default_tags      = var.default_tags

  # VPC
  cidr_etl_network_vpc     = var.cidr_etl_network_vpc
  cidr_etl_network_private = var.cidr_etl_network_private
  cidr_etl_network_public  = var.cidr_etl_network_public
}
