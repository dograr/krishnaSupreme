#Define the VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "dograr-vpc"
  }
}

resource "aws_vpc" "default1" {
  cidr_block = "${var.vpc_2_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "dograr-2-vpc"
  }
}


resource "aws_vpc_peering_connection" "test" {
  peer_vpc_id = "${aws_vpc.default.id}"
  vpc_id = "${aws_vpc.default1.id}"
}

#Define the public subnet
resource "aws_subnet" "public_subnet" {
  cidr_block = "${var.public_subnet_cidr}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "us-east-2a"

  tags = {
    Name="Web Public Subnet"
  }
}

#Define the private subnet

resource "aws_subnet" "private_subnet" {
  cidr_block = "${var.private_subnet_cidr}"
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "us-east-2b"
  tags  = {
    Name="db-private-Subnet"
  }
}

resource "aws_subnet" "private_subnet2" {
  cidr_block = "${var.private_subnet_2_cidr}"
  vpc_id = "${aws_vpc.default1.id}"
  availability_zone = "us-east-2b"
  tags  = {
    Name="db-private-Subnet-2"
  }
}


#Define the internt gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "VPC-IGW"
  }
}

#Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name =  "Public-Subnet-RT"
  }

}

#Define the route table
resource "aws_route_table" "db-private-rt" {
  vpc_id = "${aws_vpc.default.id}"
  route{
    cidr_block = "10.200.2.0/24"
    gateway_id = "${aws_vpc_peering_connection.test.id}"
  }
  tags = {
    Name =  "Private-Subnet-RT"
  }

}

resource "aws_route_table" "db-private-rt2" {
  vpc_id = "${aws_vpc.default1.id}"
  route{
    cidr_block = "10.100.2.0/24"
    gateway_id = "${aws_vpc_peering_connection.test.id}"
  }
  tags = {
     Name = "Private-Subnet-RT-2"
  }
}


#assigne the route table to the public subnet
resource "aws_route_table_association" "web-public-rt" {
  route_table_id = "${aws_route_table.web-public-rt.id}"
  subnet_id = "${aws_subnet.public_subnet.id}"
}

resource "aws_route_table_association" "db-private-rt" {
  route_table_id = "${aws_route_table.db-private-rt.id}"
  subnet_id = "${aws_subnet.private_subnet.id}"
}

resource "aws_route_table_association" "db-private-rt2" {
  route_table_id = "${aws_route_table.db-private-rt2.id}"
  subnet_id = "${aws_subnet.private_subnet2.id}"
}




#Define security group for public subnet
resource "aws_security_group" "sgweb" {
  name = "vpc-web"
  description = "allow incoming connections and ssh connections"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.default.id}"

  tags = {
    Name = "Web Server SG"
  }

}

# Define the security group for private subnet
resource "aws_security_group" "sgdb"{
  name = "sg_test_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "DB SG"
  }
}

resource "aws_security_group" "sgdb2"{
  name = "sg_test_web2"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.default1.id}"

  tags = {
    Name = "DB SG2"
  }
}

