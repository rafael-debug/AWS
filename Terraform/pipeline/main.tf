terraform {
  required_version = "1.3.6"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }

  }

  backend "s3" {
    bucket = "tfstate-rafael"
    key    = "pipeline-gitlab-ci/terraform.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  region     = "us-east-1"




  default_tags {
    tags = {
      Owner      = "Rafael Silva"
      managed-by = "terraform"
      bu         = "nome_bu"
      squad      = "nome_squad"
    }
  }
}

