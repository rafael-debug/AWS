terraform {
  required_version = ">=1.3.6"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }

  }

  # backend "s3" {
  #   bucket = "tfstate-rafael"
  #   key    = "aws-dr/terraform.tfstate"
  #   region = "us-east-2"
  # }

}

provider "aws" {
  region     = var.location_norte_virginia
  access_key = ""
  secret_key = ""


  default_tags {
    tags = {
      Owner      = "Rafael Silva"
      managed-by = "terraform"
      Ambiente         = "DisasterRecovery"
    }
  }
}





