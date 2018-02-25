variable "env" {}
variable "name" {}
variable "vpc_cidr" {}
variable "az" { type = "list" }
variable "public_subnet_cidrs" { type = "list" }
variable "private_subnet_cidrs" { type = "list" }
variable "destination_cidr_block" { default = "0.0.0.0/0"}


output "private_subnet_id" {  value = "${module.private_subnet.id}" }
output "public_subnet_id" {  value = "${module.public_subnet.id}" }
output "security_group.ids" { value = "${module.security_group.ids}"}

module "vpc" {
  source = "../vpc"

  env = "${var.env}"
  cidr = "${var.vpc_cidr}"
}

module "public_subnet" {
  source = "../subnet"

  name = "${var.env}_public_subnet"
  env = "${var.env}"
  vpc_id = "${module.vpc.id}"
  cidrs = "${var.public_subnet_cidrs}"
  az = "${var.az}"
}

module "private_subnet" {
  source = "../subnet"

  name = "${var.env}_private_subnet"
  env = "${var.env}"
  vpc_id = "${module.vpc.id}"
  cidrs = "${var.private_subnet_cidrs}"
  az = "${var.az}"
}

module "nat_gateway" {
  source = "../nat"

  subnet_ids = ["${module.public_subnet.id}"]
  subnet_count = "${length(var.public_subnet_cidrs)}"
  env = "${var.env}"
}

module "security_group" {
  source = "../security_groups"

  env = "${var.env}"
  vpc_id = "${module.vpc.id}"
}

resource "aws_route" "public_internet_gateway_route" {
  count = "${length(var.public_subnet_cidrs)}"
  route_table_id = "${element(module.public_subnet.route_table_ids, count.index)}"
  gateway_id = "${module.vpc.igw}"
  destination_cidr_block = "${var.destination_cidr_block}"
}


resource "aws_route" "private_nat_route" {
  count = "${length(var.private_subnet_cidrs)}"
  route_table_id = "${element(module.private_subnet.route_table_ids, count.index)}"
  nat_gateway_id = "${module.nat_gateway.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
}
