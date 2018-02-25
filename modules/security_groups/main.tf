variable "vpc_id" {}
variable "env" {}

output ids { value = ["${aws_security_group.public.*.id}"]}

resource "aws_security_group" "public" {
  name = "FrontEnd-${var.env}"
  vpc_id = "${var.vpc_id}"

  # allow http and ssh
  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
        Name = "FrontEnd-${var.env}"
  }

}
