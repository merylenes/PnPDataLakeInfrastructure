# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_etl_network_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace("${var.default_tags.Application}-etl-${var.short_environment}-${var.short_region}", "_", "-"))
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace("${var.default_tags.Application}-etl-internet-gateway-${var.short_environment}-${var.short_region}", "_", "-"))
    }
  )
}
