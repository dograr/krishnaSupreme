# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "myKeyPair"
  public_key = "${file("${var.key_path}")}"
}

#define webserver inside the public subnet
resource "aws_instance" "wb" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("userdata.sh")}"

  tags = {
    Name = "webserver"
  }
}

#define webserver inside the public subnet
resource "aws_instance" "db" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgdb.id}"]
  source_dest_check = false

  tags = {
    Name = "database"
  }
}

resource "aws_instance" "db1" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.private_subnet2.id}"
  vpc_security_group_ids = ["${aws_security_group.sgdb2.id}"]
  source_dest_check = false

  tags = {
    Name = "database"
  }
}
