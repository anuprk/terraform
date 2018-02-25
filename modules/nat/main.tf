variable "env" {}
variable "subnet_ids" { type = "list" }
variable "subnet_count" {}

output "id" { value = "${aws_nat_gateway.nat.id}" }

resource "aws_eip" "eip" {
  vpc   = true
}

# Create nat_gateway using elastic ip
resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id     = "${element(var.subnet_ids, count.index)}"
//  depends_on = ["aws_internet_gateway"] # create nat_gateway only if internet gateway
}
