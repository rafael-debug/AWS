resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"

}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table.id
}

## sg webserver
resource "aws_security_group" "sg-WebServerSG" {
  name   = "WebServerSG"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.portas_webserver
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
    }
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg de saida"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0

  }
}

##sg lb
resource "aws_security_group" "sg-LoadBalancerSG" {
  name   = "LoadBalancerSG"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.portas_loadbalancer
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
    }
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg de saida"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0

  }
}


##sg null
resource "aws_security_group" "sg-NullSG" {
  name   = "sg_NullSG"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.portas_nullsg
    content {
      cidr_blocks = ["0.0.0.0/0"]
      description = "entrada http"
      from_port   = ingress.value
      protocol    = "-1"
      to_port     = ingress.value
    }
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg de saida"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0

  }
}
