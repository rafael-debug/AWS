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
    key = "aws-vpc/terraform.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  region     = var.location
  access_key = "AKIA4DX5JMGFPPOJYUHE"
  secret_key = "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"


  default_tags {
    tags = {
      Owner      = "Rafael Silva"
      managed-by = "terraform"
      bu         = "nome_bu"
      squad      = "nome_squad"
    }
  }
}






# output "remote_bucket_arn_this" {
#   value = aws_s3_bucket.this.arn
# }

# output "remote_bucket_this" {
#   value = aws_s3_bucket.this.bucket
# }

# output "remote_ec2_arn" {
#   value = aws_instance.ec2.arn

# }

# output "remote_ec2_name" {
#   value = aws_instance.ec2.tags

# }