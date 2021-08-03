resource "aws_security_group_rule" "egress_cidr" {
  count = "${var.egress_cidr_count}"

  security_group_id = "${aws_security_group.security_group.id}"
  type              = "egress"
  cidr_blocks       = ["${var.egress_cidr_blocks[count.index]}"]
  from_port         = "${var.egress_cidr_ports[count.index]}"
  to_port           = "${var.egress_cidr_ports[count.index]}"
  protocol          = "${var.egress_cidr_protocols[count.index]}"
}

resource "aws_security_group_rule" "egress_sg" {
  count = "${var.egress_sg_count}"

  security_group_id        = "${aws_security_group.security_group.id}"
  type                     = "egress"
  source_security_group_id = "${var.egress_sg_sources[count.index]}"
  from_port                = "${var.egress_sg_ports[count.index]}"
  to_port                  = "${var.egress_sg_ports[count.index]}"
  protocol                 = "${var.egress_sg_protocols[count.index]}"
}
