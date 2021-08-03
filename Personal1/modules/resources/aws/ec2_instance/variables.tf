variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = ""
}

variable "ami_id" {
  description = "AMI ID to use for generating the instance"
}

variable "instance_type" {
  description = "Type of instance to use"
}

variable "vpc_security_group_ids" {
  description = "Security groups IDs"
  type        = "list"
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "ebs_optimized" {
  description = "Whether the instance has been optimized for the use of EBS"
  default     = false
}

variable "key_name" {
  description = "Key pair to use"
}

variable "iam_instance_profile" {
  description = "IAM instance profile set for this instance"
  default     = ""
}

variable "tag_name" {
  description = "Tag name"
}

variable "instance_tags" {
  description = "Tags for the EC2 instance"
  type        = "map"
}

variable "volume_tags" {
  description = "Tags for the EC2 instance"
  type        = "map"
}
