output "private_hosted_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}


output "ntc_certificate_arn" {
  value = "${aws_acm_certificate.nol_cert.arn}"
}

output "nol_certificate_arn" {
  value = "${aws_acm_certificate.nol_cert.arn}"
}