# Create subnet and add appropriate tags.

variable "name" {}
variable "env" {}
variable "vpc_id" {}
variable "cidrs" { type = "list" }
variable "az" { type = "list" }

output "id" { value = "${aws_subnet.subnet.id}" }
output "route_table_ids" { value = ["${aws_route_table.route_table.*.id}"]}

resource "aws_subnet" "subnet" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(var.cidrs, count.index)}"
  availability_zone = "${element(var.az, count.index)}"
  count = "${length(var.cidrs)}"

  tags {
      Name = "${var.name}_${element(var.az, count.index)}"
      Environment = "${var.env}"
    }
}

# create acls
resource "aws_network_acl" "all" {
   vpc_id = "${var.vpc_id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "open acl"
    }
}



# Create route table and set tags.
resource "aws_route_table" "route_table" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.cidrs)}"

  tags {
    Name = "${var.name}_${element(var.az, count.index)}"
    Environment = "${var.env}"
  }
}

# Create assocication between subnet and route tables
resource "aws_route_table_association" "route_table_asso" {
  subnet_id = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.route_table.*.id, count.index)}"
  count  = "${length(var.cidrs)}"
}
