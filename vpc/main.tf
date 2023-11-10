locals {
  subnet_char = ["a", "b", "c"]
  environment = upper((terraform.workspace))
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "Main"
    Environment = local.environment
  }
}

data "aws_region" "current" {

}

resource "aws_subnet" "main" {
  count = length(local.subnet_char)

  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${data.aws_region.current.name}${local.subnet_char[count.index]}"
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Main - ${local.subnet_char[count.index]}"
    Environment = local.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Main - IGW"
    Environment = local.environment
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "Main - RT"
    Environment = local.environment
  }
}

resource "aws_route_table_association" "main" {
  count          = length(aws_subnet.main)
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main[count.index].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.main[*].id
}

output "environment" {
  value = local.environment
}
