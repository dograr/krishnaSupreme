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
  subnet_id = "${aws_subnet.public_subnet_1.id}"
  vpc_security_group_ids = ["${aws_security_group.kafka1.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("userdata.sh")}"

  tags = {
    Name = "webserver"
  }
}

/*resource "aws_s3_bucket" "kafkamsk" {
  bucket = "kafkamsk"
  acl    = "private"

  tags = {
    Name        = "kafkamsk"
    Environment = "Dev"
  }
}*/

/*
resource "aws_msk_cluster" "dogramsk" {
  cluster_name           = "dogramsk"
  kafka_version          = "2.3.1"
  number_of_broker_nodes = 2

  broker_node_group_info {

    instance_type   = "kafka.m5.large"
    ebs_volume_size = 100
    client_subnets = [
      "${aws_subnet.public_subnet_1.id}",
      "${aws_subnet.public_subnet_2.id}",
    ]
    security_groups = ["${aws_security_group.kafka1.id}"]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  */
/*logging_info {
    broker_logs {
      s3{
        enabled = true
        bucket  = "${aws_s3_bucket.kafkamsk.id}"
        prefix  = "logs/msk-"
      }
    }
  }*//*

}
*/


/*output "zookeeper_connect_string" {
  value = "${aws_msk_cluster.dogramsk.zookeeper_connect_string}"
}

output "bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = "${aws_msk_cluster.dogramsk.bootstrap_brokers}"
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = "${aws_msk_cluster.dogramsk.bootstrap_brokers_tls}"
}

resource "aws_msk_configuration" "example" {
  kafka_versions = ["2.2.1"]
  name           = "example"

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
PROPERTIES
}*/

/*
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
*/