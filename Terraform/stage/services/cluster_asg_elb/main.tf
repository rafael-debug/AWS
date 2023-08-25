provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      terraform = "true"
      ambiente  = "${var.prodORqa == "prod" ? "prod" : "qa"}"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }
    radom = {
      source  = "hashicorp/random"
      version = "~>3.4.3"
    }

  }

}

terraform {
  backend "s3" {
    bucket = "tfstate-rafael"
    key    = "iac-cluster-asg-elb"
    region = "us-east-1"

    #dynamodb_table = ""
    #encrypt = true
  }
}



data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  #vpc_id = data.aws_vpc.default.id
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }


  owners = ["099720109477"]
}