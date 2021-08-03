variable "cidr_block" {
  description = "VPC CIDR block"
}

variable "tag_name_vpc" {
  description = "Tag name for the VPC"
}

variable "tags" {
  description = "Required tags"
  type        = "map"
}

variable "enable_dns_hostnames" {
  description = "Enable/disable DNS hostnames in the VPC"
  default     = true
}
