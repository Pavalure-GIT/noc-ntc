// Prometheus app security group ID
output "prometheus_sg_id" {
  value = "${aws_security_group.prom_app_sg.id}"
}
