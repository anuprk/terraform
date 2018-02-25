variable "env" {}
variable "vpc_cidr" {}
variable "az" { type = "list"}
variable "public_subnet_cidrs" { type = "list" }
variable "private_subnet_cidrs" { type = "list" }
variable "instance_aws_ami" {}
variable "instance_type" {}



module "network" {
  source = "../network"

  name = "${var.env}"
  env = "${var.env}"
  vpc_cidr = "${var.vpc_cidr}"
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  az = "${var.az}"
}


module "ec2" {
  source = "../ec2"

  env = "${var.env}"
  ami = "${var.instance_aws_ami}"
  instance_type = "${var.instance_type}"
  public_subnet_id = "${module.network.public_subnet_id}"
  public_security_group_ids = "${module.network.security_group.ids}"
  private_subnet_id = "${module.network.private_subnet_id}"
  # private_security_group_ids = "${module.network.security_group.ids}"
}
