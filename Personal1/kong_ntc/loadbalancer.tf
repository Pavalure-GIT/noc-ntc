resource "aws_alb" "apigw_ntc" {
  name     = "apigw-lb-ntc-${terraform.workspace}"
  internal = true
  subnets = ["${local.private_subnets[terraform.workspace]}"]
  security_groups = ["${aws_security_group.main_alb.id}"]
  load_balancer_type = "application"

  tags   = "${merge(local.tags, map("Name", "NTC Kong Load Balancer - ${terraform.workspace}"))}"
}

resource "aws_alb_listener" "apigw_ntc" {
  load_balancer_arn = "${aws_alb.apigw_ntc.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_cert_arn[terraform.workspace]}"
  default_action {
    target_group_arn = "${aws_alb_target_group.apigw_ntc.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "ntc_redirect" {
  listener_arn = "${aws_alb_listener.apigw_ntc.arn}"
  priority     = 100
  action {
    type   = "redirect"
    redirect {
      port = "#{port}"
      host = "#{host}"
      path = "/ntc/exe/beginsso"
      query = "#{query}"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  condition {
    field  = "path-pattern"
    values = ["/"]
  }
}

resource "aws_alb_listener" "apigw_ntc_admin2" {
  load_balancer_arn = "${aws_alb.apigw_ntc.arn}"
  port              = "8001"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.apigw_ntc_admin2.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "apigw_ntc" {
  name     = "apigw-ntc-${terraform.workspace}"
  port     = 8443
  protocol = "HTTPS"
  vpc_id = "${local.vpc_id[terraform.workspace]}"
}

resource "aws_alb_target_group" "apigw_ntc_admin" {
  name     = "apigw-admin-ntc-${terraform.workspace}"
  port     = 8444
  protocol = "HTTPS"
  vpc_id = "${local.vpc_id[terraform.workspace]}"
}

resource "aws_alb_target_group" "apigw_ntc_admin2" {
  name     = "apigw-admin2-ntc-${terraform.workspace}"
  port     = 8001
  protocol = "HTTP"
  vpc_id   = "${local.vpc_id[terraform.workspace]}"
}

resource "aws_autoscaling_attachment" "apigw_ntc" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  alb_target_group_arn   = "${aws_alb_target_group.apigw_ntc.arn}"
}

resource "aws_autoscaling_attachment" "apigw_ntc_admin" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  alb_target_group_arn   = "${aws_alb_target_group.apigw_ntc_admin.arn}"
}

resource "aws_autoscaling_attachment" "apigw_ntc_admin2" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  alb_target_group_arn   = "${aws_alb_target_group.apigw_ntc_admin2.arn}"
}
