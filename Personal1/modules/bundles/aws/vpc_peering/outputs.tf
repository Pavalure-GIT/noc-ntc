// VPC peering connection ID
output "peering_connection_id" {
  value = "${aws_vpc_peering_connection.peering_request.id}"
}
