variable "peer_account_id" {
  description = "Account ID of the shared VPC"
  default     = ""
}

variable "peer_vpc_id" {
  description = "VPC ID of the shared VPC"
}

variable "local_vpc_id" {
  description = "VPC ID of the local VPC"
}

variable "auto_accept" {
  description = "Auto-accept peering request (just for local peering)"
}

variable "tag_name_peer" {
  description = "Tag name for the VPC peering connection"
}

variable "tags" {
  description = "Required tags"
  type        = "map"
}
