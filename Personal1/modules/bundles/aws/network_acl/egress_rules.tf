resource "aws_network_acl_rule" "egress" {
  count          = "${var.egress_count}"
  network_acl_id = "${aws_network_acl.network_acl.id}"
  rule_number    = "${var.egress_count * 100}"

  egress = true

  protocol    = "${var.egress_protocols[count.index]}"
  rule_action = "${var.egress_rule_actions[count.index]}"
  cidr_block  = "${var.egress_cidr_blocks[count.index]}"
  from_port   = "${var.egress_from_ports[count.index]}"
  to_port     = "${var.egress_to_ports[count.index]}"
}
