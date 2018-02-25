variable "env" {}
variable "ami" {}
variable "instance_type" {}
variable "public_subnet_id" {}
variable "public_security_group_ids" { type = "list" }
variable "private_subnet_id" {}
# variable "private_security_group_ids" { type = "list" }


resource "aws_instance" "public_instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id = "${var.public_subnet_id}"
  vpc_security_group_ids = ["${var.public_security_group_ids}"]

  tags {
        Name = "public_instance-${var.env}"
  }
}

resource "aws_instance" "private_instance" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id = "${var.private_subnet_id}"
  # vpc_security_group_ids = ["${var.private_security_group_ids}"]

  tags {
        Name = "private_instance-${var.env}"
  }
}
