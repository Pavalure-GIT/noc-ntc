# Route definition
resource "aws_route" "route" {
  count = "${var.count}"

  destination_cidr_block    = "${element(var.destination_cidr_blocks, count.index)}"
  route_table_id            = "${element(var.route_table_ids, count.index)}"
  vpc_peering_connection_id = "${element(var.vpc_peering_connection_ids, count.index)}"

  #  depends_on                	= ["${var.route_table}"]
}
