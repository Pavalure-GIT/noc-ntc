resource "aws_security_group_rule" "ingress_cidr" {
  count = "${var.ingress_cidr_count}"

  security_group_id = "${aws_security_group.security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["${var.ingress_cidr_blocks[count.index]}"]
  from_port         = "${var.ingress_cidr_ports[count.index]}"
  to_port           = "${var.ingress_cidr_ports[count.index]}"
  protocol          = "${var.ingress_cidr_protocols[count.index]}"
}

resource "aws_security_group_rule" "ingress_sg" {
  count = "${var.ingress_sg_count}"

  security_group_id        = "${aws_security_group.security_group.id}"
  type                     = "ingress"
  source_security_group_id = "${var.ingress_sg_sources[count.index]}"
  from_port                = "${var.ingress_sg_ports[count.index]}"
  to_port                  = "${var.ingress_sg_ports[count.index]}"
  protocol                 = "${var.ingress_sg_protocols[count.index]}"
}
