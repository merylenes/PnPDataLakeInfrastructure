resource "aws_route53_zone" "datalake_internal" {
  name = "datalake.${var.short_environment}"

  vpc {
    vpc_region = var.aws_region
    vpc_id     = var.vpc_ids[0]
  }

  lifecycle {
    ignore_changes = [vpc]
  }

  tags = merge(var.default_tags, 
    {
      Name        = "datalake.${var.short_environment}"
      Description = "Private DNS zone for the Data Lake ETL ${title(var.short_environment)} environment"
    }
  )
}

# Manage any additional VPC associations separately.
# resource "aws_route53_zone_association" "secondary" {
#   for_each = var.vpc_ids

#   zone_id = aws_route53_zone.datalake_internal.zone_id
#   vpc_ids  = each.key
# }
