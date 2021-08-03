variable "vpc_id" {
  description = "VPC ID"
}

variable "ingress_cidr_count" {
  description = "Number of ingress rules based on CIDR blocks"
  default     = 0
}

variable "ingress_sg_count" {
  description = "Number of ingress rules based on security group sources"
  default     = 0
}

variable "egress_cidr_count" {
  description = "Number of egress rules based on CIDR blocks"
  default     = 0
}

variable "egress_sg_count" {
  description = "Number of egress rules based on security group sources"
  default     = 0
}

variable "ingress_cidr_blocks" {
  type        = "list"
  description = "List of CIDR blocks for ingress rules"
  default     = []
}

variable "ingress_cidr_protocols" {
  type        = "list"
  description = "List of protocols ingress rules based on CIDR blocks"
  default     = []
}

variable "ingress_cidr_ports" {
  type        = "list"
  description = "List of from_port/to_port ingress rules based on CIDR blocks"
  default     = []
}

variable "ingress_sg_sources" {
  type        = "list"
  description = "List of sources for ingress rules based on security group sources"
  default     = []
}

variable "ingress_sg_protocols" {
  type        = "list"
  description = "List of protocols ingress rules based on security group sources"
  default     = []
}

variable "ingress_sg_ports" {
  type        = "list"
  description = "List of from_port/to_port ingress rules based on security group sources"
  default     = []
}

variable "egress_cidr_blocks" {
  type        = "list"
  description = "List of CIDR blocks for egress rules"
  default     = []
}

variable "egress_cidr_protocols" {
  type        = "list"
  description = "List of protocols egress rules based on CIDR blocks"
  default     = []
}

variable "egress_cidr_ports" {
  type        = "list"
  description = "List of from_port/to_port egress rules based on CIDR blocks"
  default     = []
}

variable "egress_sg_sources" {
  type        = "list"
  description = "List of sources for egress rules based on security group sources"
  default     = []
}

variable "egress_sg_protocols" {
  type        = "list"
  description = "List of protocols egress rules based on security group sources"
  default     = []
}

variable "egress_sg_ports" {
  type        = "list"
  description = "List of from_port/to_port egress rules based on security group sources"
  default     = []
}

variable "tag_name" {
  description = "Name of the security group"
}

variable "tags" {
  description = "Required tags"
  type        = "map"
}
