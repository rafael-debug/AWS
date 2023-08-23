
variable "location_oregon" {
  type        = string
  description = "region us-west-2"
  default     = "us-west-2"
}

variable "location_norte_virginia" {
  type        = string
  description = "region us-east-1"
  default     = "us-east-2"
}

variable "environment_prod" {
  type        = string
  description = "prod"
  default     = "prod"
}

variable "terraform" {
  type    = string
  default = "terraform"
}

variable "ec2_ami" {
  type = string
}

variable "ec2_type" {
  type = string
}

variable "portas_webserver" {
  description = "lista de portas do sg WebServerSG"
  type        = list(number)

}

variable "portas_loadbalancer" {
  description = "Lista de portas do sg LoadBalancerSG"
  type        = list(number)
}

variable "portas_nullsg" {
  description = "Lista de portas do sg sg-NullSG"
  type        = list(number)
}
