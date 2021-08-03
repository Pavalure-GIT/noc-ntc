resource "aws_route_table" "route_table" {
  count = "${var.count}"

  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", element(var.tag_name_route_tables, count.index)))}"
}

resource "aws_route_table_association" "association_subnet_route_table" {
  count = "${var.count}"

  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.route_table.*.id, count.index)}"
}

/*
resource "aws_route" "route" {
  count = "${var.count}"

  destination_cidr_block = "${element(var.destination_cidr_blocks, count.index)}"
  route_table_id         = "${element(aws_route_table.route_table.*.id, count.index)}"
  nat_gateway_id         = "${element(var.nat_gateways, count.index)}"
}
*/

