variable "count" {
  description = "Number of subnet to create"
}

variable "destination_cidr_blocks" {
  type        = "list"
  description = "Routing destination CIDR block list"
}

variable "route_table_ids" {
  type        = "list"
  description = "Route table ID list"
}

variable "vpc_peering_connection_ids" {
  type        = "list"
  description = "VPC peering connection ID list"
}
