resource "aws_elb" "prom_elb" {
  name = "${var.resources_prefix}-${var.prom_elb_name}-${var.environment}"

  internal = "true"

  subnets         = ["${local.private_subnets[terraform.workspace]}"]
  security_groups = ["${aws_security_group.prom_elb_sg.id}"]

  listener {
    instance_port      = 9090
    instance_protocol  = "TCP"
    lb_port            = 9090
    lb_protocol        = "TCP"
  }

  listener {
    instance_port      = 9091
    instance_protocol  = "TCP"
    lb_port            = 9091
    lb_protocol        = "TCP"
  }

  health_check {
    healthy_threshold   = "${var.elb_healthy_threshold}"
    unhealthy_threshold = "${var.elb_unhealthy_threshold}"
    timeout             = "${var.elb_healthy_timeout}"
    target              = "HTTP:9090/-/healthy"
    interval            = "${var.elb_healthy_interval}"
  }

  tags = "${var.prom_tags}"
}

resource "aws_elb" "grafana_elb" {
  name = "${var.resources_prefix}-${var.grafana_elb_name}-${var.environment}"

  internal = "${var.grafana_elb_internal}"

  subnets         = ["${local.private_subnets[terraform.workspace]}"]
  security_groups = ["${aws_security_group.grafana_elb_sg.id}"]

  access_logs {
    bucket        = "${local.elb_logs_bucket}"
    bucket_prefix = "${var.service_s3_elb_logs_prefix}"
    interval      = "${var.elb_logs_interval}"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "TCP"
    lb_port            = 443
    lb_protocol        = "TCP"
  }

  health_check {
    healthy_threshold   = "${var.elb_healthy_threshold}"
    unhealthy_threshold = "${var.elb_unhealthy_threshold}"
    timeout             = "${var.elb_healthy_timeout}"
    target              = "${var.elb_healthy_target}"
    interval            = "${var.elb_healthy_interval}"
  }

  tags = "${var.grafana_tags}"
}
