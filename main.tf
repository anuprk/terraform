variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "env" {}
variable "vpc_cidr" {}
variable "az" { type = "list"}
variable "public_subnet_cidrs" { type = "list" }
variable "private_subnet_cidrs" { type = "list" }
variable "instance_aws_ami" {}
variable "instance_type" {}


provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"

	region = "${var.region}"
}

module "biotech" {
  source = "./modules/biotech"

  env = "${var.env}"
  vpc_cidr = "${var.vpc_cidr}"
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  instance_aws_ami = "${var.instance_aws_ami}"
  instance_type = "${var.instance_type}"
  az = "${var.az}"

}
