variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private Subnet"
  default = "10.0.2.0/24"
}

variable "ami" {
  description = "t2.micro ami"
  default = "ami-0e01ce4ee18447327"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "mykeyPairPub"
}
