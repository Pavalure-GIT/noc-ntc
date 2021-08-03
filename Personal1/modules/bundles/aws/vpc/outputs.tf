// VPC ID
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr_block" {
  value = "${var.cidr_block}"
}
