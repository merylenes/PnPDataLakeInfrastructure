# Route Table
resource "aws_route_table" "private" {
  count  = length(var.subnet_azs)
  vpc_id = aws_vpc.vpc.id

  route {
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
    cidr_block     = "0.0.0.0/0"
  }

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(format("%s-etl-private-route-%s-%s%s", var.default_tags.Application, var.short_environment, var.short_region, var.subnet_azs[count.index]), "_", "-"))
    }
  )
}

# Subnets
resource "aws_subnet" "private" {
  count             = length(var.subnet_azs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_etl_network_private[count.index]  # TODO:  update
  availability_zone = format("%s%s", var.aws_region, var.subnet_azs[count.index])

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(format("%s-etl-private-%s-%s%s", var.default_tags.Application, var.short_environment, var.short_region, var.subnet_azs[count.index]), "_", "-")),
      Tier = "Private"
    }
  )
}

# Routing
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
