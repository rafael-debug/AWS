locals {

  object_filepath = "index.html"

  common_tags = {
    Name        = "my-bucket-staticpage-disasterrecovery"
    service     = "web site"
    ManagedBy   = "Terraform"
    Environment = var.environment_prod
    Owner       = "pinção"
  }
}
