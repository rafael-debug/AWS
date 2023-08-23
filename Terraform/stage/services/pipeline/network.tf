resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.vpc_tag
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = var.vpc_subnet
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.gw
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = var.routet


}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg" {
  name   = "security-group-terraform"
  vpc_id = aws_vpc.vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg de entrada"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg de saida"
    from_port   = 0
    protocol    = "tcp"
    to_port     = 0


  }
  tags = {
    "Name" = "security-group-terraform"
  }
}