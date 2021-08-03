output "ntc_alb_dns" {
  value = "${aws_alb.ntc-alb.dns_name}"
}


output "ntc_db_sg_id" {
  value = "${aws_security_group.ntc-db-sg.id}"
}

output "ntc_db_subnet_name" {
  value = "${aws_db_subnet_group.subnet_group.name}"
}
