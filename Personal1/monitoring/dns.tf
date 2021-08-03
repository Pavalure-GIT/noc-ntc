resource "aws_route53_record" "grafana" {
  zone_id = "${data.aws_route53_zone.route53_zone.zone_id}"
  name    = "${var.grafana_alt_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.grafana_elb.dns_name}"
    zone_id                = "${aws_elb.grafana_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "prom" {
  zone_id = "${data.aws_route53_zone.route53_zone.zone_id}"
  name    = "prometheus.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.prom_elb.dns_name}"
    zone_id                = "${aws_elb.prom_elb.zone_id}"
    evaluate_target_health = true
  }
}

