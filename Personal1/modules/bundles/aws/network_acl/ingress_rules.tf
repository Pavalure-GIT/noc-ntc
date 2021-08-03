resource "aws_network_acl_rule" "ingress" {
  count          = "${var.ingress_count}"
  network_acl_id = "${aws_network_acl.network_acl.id}"
  rule_number    = "${var.ingress_count * 100}"

  egress = false

  protocol    = "${var.ingress_protocols[count.index]}"
  rule_action = "${var.ingress_rule_actions[count.index]}"
  cidr_block  = "${var.ingress_cidr_blocks[count.index]}"
  from_port   = "${var.ingress_from_ports[count.index]}"
  to_port     = "${var.ingress_to_ports[count.index]}"
}
