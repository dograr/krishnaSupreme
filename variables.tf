variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.100.0.0/16"
}
/*
variable "vpc_2_cidr" {
  description = "CIDR for the VPC 2"
  default = "10.200.0.0/16"
}
*/
variable "public_subnet_cidr" {
  description = "Public subnet"
  default = "10.100.1.0/24"
}

variable "public_subnet2_cidr" {
  description = "Public subnet"
  default = "10.100.2.0/24"
}
/*
variable "private_subnet_cidr" {
  description = "Private Subnet"
  default = "10.100.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet"
  default = "10.200.2.0/24"
}
*/
variable "ami" {
  description = "t2.micro ami"
  default = "ami-0e01ce4ee18447327"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "mykeyPairPub"
}
