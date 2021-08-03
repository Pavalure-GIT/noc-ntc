// List of subnet IDs
output "subnet_ids" {
  value = "${aws_subnet.subnet.*.id}"
}

// List of route table IDs
output "route_table_ids" {
  value = "${aws_route_table.route_table.*.id}"
}
