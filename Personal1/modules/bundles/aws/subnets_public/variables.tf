variable "count" {
  description = "Number of subnet to create"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "map_public_ip_on_launch" {
  description = "True if the instances into the subnet should be assigned a public IP address"
  default     = true
}

variable "availability_zones" {
  type        = "list"
  description = "Availability zone list"
}

variable "cidr_blocks" {
  type        = "list"
  description = "CIDR block list"
}

variable "internet_gateway" {
  description = "Internet gateway"
}

variable "destination_cidr_blocks" {
  type        = "list"
  description = "Routing destination CIDR block list"
}

variable "tag_name_subnets" {
  type        = "list"
  description = "Tag Name list for the subnets"
}

variable "tag_name_route_tables" {
  type        = "list"
  description = "Tag Name list for the route tables"
}

variable "tags" {
  description = "Required tags"
  type        = "map"
}
