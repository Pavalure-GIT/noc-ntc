variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of subnet IDs to apply the ACL to"
}

variable "tag_name" {
  description = "Name of the ACL"
}

variable "tags" {
  description = "Required tags"
  type        = "map"
}

variable "ingress_count" {
  description = "Number of ingress rules"
  default     = 0
}

variable "ingress_rule_actions" {
  type        = "list"
  default     = []
  description = "List of 'allow' or 'deny' instructions for the ingress rules"
}

variable "ingress_cidr_blocks" {
  type        = "list"
  default     = []
  description = "List of network ranges for the ingress rules"
}

variable "ingress_from_ports" {
  type        = "list"
  default     = []
  description = "List of 'from_port' parameters for the ingress rules"
}

variable "ingress_to_ports" {
  type        = "list"
  default     = []
  description = "List of 'to_port' parameters for the ingress rules"
}

variable "ingress_protocols" {
  type        = "list"
  default     = []
  description = "List of 'protocol' parameters for the ingress rules"
}

variable "egress_count" {
  description = "Number of egress rules"
  default     = 0
}

variable "egress_rule_actions" {
  type        = "list"
  default     = []
  description = "List of 'allow' or 'deny' instructions for the egress rules"
}

variable "egress_cidr_blocks" {
  type        = "list"
  default     = []
  description = "List of network ranges for the egress rules"
}

variable "egress_from_ports" {
  type        = "list"
  default     = []
  description = "List of 'from_port' parameters for the egress rules"
}

variable "egress_to_ports" {
  type        = "list"
  default     = []
  description = "List of 'to_port' parameters for the egress rules"
}

variable "egress_protocols" {
  type        = "list"
  default     = []
  description = "List of 'protocol' parameters for the egress rules"
}
