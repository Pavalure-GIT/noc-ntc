# Internal record to route to the ecs services.
/*
resource "aws_route53_record" "ecs" {
  zone_id = "${var.zone_id}"
  name    = "${var.sub_domain}.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.apigw.dns_name}"
    zone_id                = "${aws_alb.apigw.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.domain}"
#  subject_alternative_names = ["${var.sub-domain}"]
  validation_method         = "DNS"
}
resource "aws_route53_zone" "zone" {
    name            = "${var.domain}"
    comment         = "KONG_NOL Staging private hosted zone"
    vpc             = {
      vpc_id        = "${local.vpc_id[terraform.workspace]}"
   }
    tags {
     Environment    = "kong-nol-${terraform.workspace}"
   }
    lifecycle {
     create_before_destroy = true
   }
}

resource "aws_route53_record" "nol_acm_validation" {
  #name            = "www.${var.domain}"
  name            = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  zone_id         = "${aws_route53_zone.zone.zone_id}"
  type            = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  ttl             = "${var.ttl}"
  weighted_routing_policy {
    weight        = 10
  }
  set_identifier  = "${terraform.workspace}"
  records         = ["${var.domain}"]
  
}
/*
resource "aws_route53_record" "ecs" {
  zone_id = "${var.zone_id}"
  name    = "${var.sub_domain}.${var.domain}"
  type    = "A"
resource "aws_route53_record" "acm_validation" {
  zone_id         = "${aws_route53_zone.zone.zone_id}"
  name            = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type            = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  ttl             = "${var.ttl}"
  #records         = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  records         = ["${var.sub-domain}"]
  
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.nol_acm_validation.fqdn}",
#    "${aws_route53_record.acm_validation.fqdn}",
  ]
}


resource "aws_alb_listener" "nol-route53" {
  load_balancer_arn = "${aws_alb.apigw_nol.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = "${aws_acm_certificate_validation.cert.certificate_arn}"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  default_action {
    target_group_arn = "${aws_alb_target_group.apigw_nol.arn}"
    type             = "forward"
  }
}*/


