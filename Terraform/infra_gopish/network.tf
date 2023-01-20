resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags =  var.vpc_tag
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.1.1.0/24"

  tags = var.vpc_subnet
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.gw
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
}