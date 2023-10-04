# NAT Subnet
resource "aws_subnet" "nat" {
  count                   = length(var.subnet_azs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_etl_network_public[count.index]
  availability_zone       = format("%s%s", var.aws_region, var.subnet_azs[count.index])
  map_public_ip_on_launch = true

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(format("%s-etl-public-%s-%s%s", var.default_tags.Application, var.short_environment, var.short_region, var.subnet_azs[count.index]), "_", "-")),
      Tier = "Public"
    }
  )
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = length(var.subnet_azs)
  vpc   = true

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(format("%s-etl-eip-%s-%s%s", var.default_tags.Application, var.short_environment, var.short_region, var.subnet_azs[count.index]), "_", "-"))
    }
  )
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.subnet_azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.nat[count.index].id

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(format("%s-etl-nat-gateway-%s-%s%s", var.default_tags.Application, var.short_environment, var.short_region, var.subnet_azs[count.index]), "_", "-"))
    }
  )
}

# Routing
resource "aws_route_table" "nat" {
  # count  = length(var.subnet_azs)
  vpc_id = aws_vpc.vpc.id

  route {
    gateway_id = aws_internet_gateway.internet_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(format("%s-etl-nat-route-%s-%s", var.default_tags.Application, var.short_environment, var.short_region), "_", "-"))
      # Name = lower(replace(format("%s-etl-nat-route-%s-%s%s", var.default_tags.Application, var.short_environment, var.short_region, var.subnet_azs[count.index]), "_", "-"))
    }
  )
}

resource "aws_route_table_association" "nat" {
  count          = length(var.subnet_azs)
  # subnet_id      = aws_subnet.nat.*.id[count.index]
  subnet_id      = aws_subnet.nat[count.index].id
  # route_table_id = aws_route_table.nat.*.id[count.index]
  route_table_id = aws_route_table.nat.id
}