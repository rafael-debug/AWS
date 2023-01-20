variable "location" {
  type        = string
  description = "variavel que indica a regiao que os recursos vão ser criados"
  default     = "us-east-1"
}

variable "tags_bucket" {
  type        = map(string)
  description = "tags de bucket"
  default = {
    "Name"         = "backup-storage-175820"
    "Descriptions" = "bucket de arquivos de backup do veeam."
  }
}

variable "ec2_type" {
  description = "tipo da ec2"
  type        = string
  default     = "t2.micro"

}

variable "ec2_ami" {
  description = "nome da imagem"
  type        = string

}

## TAGs

variable "ec2_tag" {
  type        = map(string)
  description = "tags ec2"
  default = {
  "owner_ec2" = "rafael"
  "Name"      = "ec2_teste"

}

  }

variable "vpc_tag" {
  type = map(string)
  description = "tags VPC"
  default = {
    "Name" = "vpc-terraform"
  }
}

variable "vpc_subnet" {
  type = map(string)
  description = "tags Subnet"
  default = {
    "Name" = "subnet-terraform"
  }
}

variable "gw" {
  type = map(string)
  description = "tags internet gateway"
  default = {
    "Name" = "GW terraform"
  }
}