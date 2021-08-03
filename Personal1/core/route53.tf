
#Note - for rsousces created manually, use terraform import aws_route53_zone.private Hosted_Zone_Id

resource "aws_route53_zone" "private" {
  name = "${var.private_hosted_zone_name[terraform.workspace]}"
  vpc {
    vpc_id = "${local.vpc_id[terraform.workspace]}"
  }
  vpc {
    vpc_id = "${var.shared_services_vpc}"
  }
}

# resource "aws_route53_zone_association" "shared_services" {
#   zone_id = "${aws_route53_zone.private.zone_id}"
#   vpc_id = "${var.shared_services_vpc}"
# }


resource "aws_acm_certificate" "nol_cert" {
  domain_name               = "${var.domain_names_nol[terraform.workspace]}"
  validation_method         = "DNS"
  
   subject_alternative_names = "${var.additional_names_nol[terraform.workspace]}"
  
}

resource "aws_acm_certificate" "ntc_cert" {
  domain_name               = "${var.domain_names_ntc[terraform.workspace]}"
  validation_method         = "DNS"

  subject_alternative_names = "${var.additional_names_ntc[terraform.workspace]}"
}


resource "aws_route53_record" "nol_acm_validation" {
  name            = "${aws_acm_certificate.nol_cert.domain_validation_options.0.resource_record_name}"
  zone_id         = "${aws_route53_zone.private.zone_id}"
  type            = "${aws_acm_certificate.nol_cert.domain_validation_options.0.resource_record_type}"
  ttl             = "300"
  weighted_routing_policy {
    weight        = 10
  }
  records = ["${aws_acm_certificate.nol_cert.domain_validation_options.0.resource_record_value}"]
  set_identifier  = "${terraform.workspace}"
  
}

resource "aws_acm_certificate_validation" "nol_cert" {
  certificate_arn         = "${aws_acm_certificate.nol_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.nol_acm_validation.fqdn}"]
}


resource "aws_route53_record" "ntc_acm_validation" {
  name            = "${aws_acm_certificate.ntc_cert.domain_validation_options.0.resource_record_name}"
  zone_id         = "${aws_route53_zone.private.zone_id}"
  type            = "${aws_acm_certificate.ntc_cert.domain_validation_options.0.resource_record_type}"
  ttl             = "300"
  weighted_routing_policy {
    weight        = 10
  }
  records = ["${aws_acm_certificate.ntc_cert.domain_validation_options.0.resource_record_value}"]
  set_identifier  = "${terraform.workspace}"
  
}

resource "aws_acm_certificate_validation" "ntc_cert" {
  certificate_arn         = "${aws_acm_certificate.ntc_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.ntc_acm_validation.fqdn}"]
}
