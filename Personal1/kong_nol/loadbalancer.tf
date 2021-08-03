resource "aws_alb" "apigw_nol" {
  name     = "apigw-lb-nol-${terraform.workspace}"
  internal = true
  subnets = ["${local.private_subnets[terraform.workspace]}"]
  security_groups = ["${aws_security_group.main_alb_nol.id}"]
  load_balancer_type = "application"

  tags   = "${merge(local.tags, map("Name", "NOL Loadbalancer -${terraform.workspace}"))}"
}

resource "aws_alb_listener" "apigw_nol" {
  load_balancer_arn = "${aws_alb.apigw_nol.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_cert_arn[terraform.workspace]}"
  default_action {
    target_group_arn = "${aws_alb_target_group.apigw_nol.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "nol_redirect" {
  listener_arn = "${aws_alb_listener.apigw_nol.arn}"
  priority     = 100
  action {
    type   = "redirect"
    redirect {
      port = "#{port}"
      host = "#{host}"
      path = "/nol/login/warning.jsp"
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


resource "aws_alb_listener" "apigw_nol_admin" {
  load_balancer_arn = "${aws_alb.apigw_nol.arn}"
  port              = "8444"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_cert_arn[terraform.workspace]}"

  default_action {
    target_group_arn = "${aws_alb_target_group.apigw_nol_admin.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "apigw_nol_admin2" {
  load_balancer_arn = "${aws_alb.apigw_nol.arn}"
  port              = "8001"
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.apigw_nol_admin2.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "apigw_nol" {
  name     = "apigw-nol-${terraform.workspace}"
  port     = 8443
  protocol = "HTTPS"
  vpc_id = "${local.vpc_id[terraform.workspace]}"
}

resource "aws_alb_target_group" "apigw_nol_admin" {
  name     = "apigw-admin-nol-${terraform.workspace}"
  port     = 8444
  protocol = "HTTPS"

  vpc_id = "${local.vpc_id[terraform.workspace]}"
}

resource "aws_alb_target_group" "apigw_nol_admin2" {
  name     = "apigw-admin2-nol-${terraform.workspace}"
  port     = 8001
  protocol = "HTTP"
  vpc_id   = "${local.vpc_id[terraform.workspace]}"
}

resource "aws_autoscaling_attachment" "apigw_nol" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  alb_target_group_arn   = "${aws_alb_target_group.apigw_nol.arn}"
}

resource "aws_autoscaling_attachment" "apigw_nol_admin" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  alb_target_group_arn   = "${aws_alb_target_group.apigw_nol_admin.arn}"
}

resource "aws_autoscaling_attachment" "apigw_nol_admin2" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  alb_target_group_arn   = "${aws_alb_target_group.apigw_nol_admin2.arn}"
}
