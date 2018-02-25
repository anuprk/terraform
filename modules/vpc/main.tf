variable "env" {}
variable "cidr" {}

output "id" { value = "${aws_vpc.vpc.id}"}
output "igw" { value = "${aws_internet_gateway.gateway.id}"}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.env}"
    Environment = "${var.env}"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Environment = "${var.env}"
  }
}
