resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags       = merge(
    {
      "Name" = format(
        "%s-%s",
        var.namespace,
        var.vpc_name
      )
    }, var.vpc_tags
  ) 
}
resource "aws_internet_gateway" "vpc" {
    vpc_id = aws_vpc.vpc.id
    tags = {"Name" = format(
        "%s-%s",
        var.namespace,
        var.igw_name
      )}
}
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  tags = {"Name" = format(
        "%s-%s-%s",
        var.namespace,
        var.public_subnets_name,
        element(var.azs, count.index)
      )}
}

# config Private_subnet
resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets)
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.private_subnets[count.index]
    availability_zone       = var.azs[count.index]
    tags = {"Name" = format(
        "%s-%s-%s",
        var.namespace,
        var.private_subnets_name,
        element(var.azs, count.index)
      )}
}

# config RDS_Subnet
resource "aws_subnet" "db_subnets" {
  count = length(var.db_subnets)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {"Name" = format(
        "%s-%s-%s",
        var.namespace,
        var.db_subnets_name,
        element(var.azs, count.index)
      )}
}

resource "aws_eip" "vpc" {
  count = var.single_nat_gateway ? 1 : length(var.azs)
  vpc = true
  tags = var.single_nat_gateway ? {"Name" = format("%s-%s", var.namespace, var.eip_name)} : {"Name" = format("%s-%s-%s", var.namespace, var.eip_name, element(var.azs, count.index))}
  depends_on = [aws_internet_gateway.vpc]
}
resource "aws_nat_gateway" "vpc" {
  count = var.single_nat_gateway ? 1 : length(var.azs)
  allocation_id = aws_eip.vpc[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
  tags = var.single_nat_gateway ? {"Name" = format("%s-%s", var.namespace, var.natgw_name)} : {"Name" = format("%s-%s-%s", var.namespace, var.natgw_name, element(var.azs, count.index))}

  depends_on = [aws_internet_gateway.vpc]
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {"Name" = format(
        "%s-%s",
        var.namespace,
        var.rtb_public_name
      )}
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc.id
}
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table" "private" {
  count = length(var.azs)

  vpc_id = aws_vpc.vpc.id

  tags = {"Name" = format(
        "%s-%s-%s",
        var.namespace,
        var.rtb_private_name,
        element(var.azs, count.index)
      )}
}

resource "aws_route" "private" {
  count = length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.vpc[0].id : aws_nat_gateway.vpc[count.index].id
}

resource "aws_route_table_association" "private_subnet_a" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_route_table_association" "db_subnet_a" {
  subnet_id      = aws_subnet.db_subnets[0].id
  route_table_id = aws_route_table.private[0].id
}
resource "aws_route_table_association" "private_subnet_c" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private[1].id
}
resource "aws_route_table_association" "db_subnet_c" {
  subnet_id      = aws_subnet.db_subnets[1].id
  route_table_id = aws_route_table.private[1].id
}