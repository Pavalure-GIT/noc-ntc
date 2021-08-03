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
*/