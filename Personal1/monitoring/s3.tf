data "template_file" "service_bucket_policy" {
  template = "${file(format("%s/assets/s3_service_bucket_policy.json", path.module))}"

  vars {
    service_s3_bucket = "${var.service_s3_bucket}"
  }
}

resource "aws_s3_bucket" "service_bucket" {
  bucket = "${var.service_s3_bucket}"
  acl    = "private"
  region = "eu-west-2"
  policy = "${data.template_file.service_bucket_policy.rendered}"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "backups"
    prefix  = "${var.service_s3_backup_prefix}/"
    enabled = true

    noncurrent_version_expiration {
     days = 90
    }
  }

  lifecycle_rule {
    id = "configs"
    prefix  = "${var.service_s3_config_prefix}/"
    enabled = true

    noncurrent_version_expiration {
     days = 14
    }
  }

  tags   = "${var.common_sg_tags}"
}


resource "aws_s3_bucket_object" "prometheus_user_config" {
  count  = "${var.prometheus_user_config == "" ? 0 : 1}"
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/prometheus.yaml"
  source = "${var.prometheus_user_config}"
  etag   = "${md5(file(var.prometheus_user_config))}"
}

resource "aws_s3_bucket_object" "alertmanager_user_config" {
  count  = "${var.prometheus_alertmanager_user_config == "" ? 0 : 1}"
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/alertmanager.yaml"
  source = "${var.prometheus_alertmanager_user_config}"
  etag   = "${md5(file(var.prometheus_alertmanager_user_config))}"
}

resource "aws_s3_bucket_object" "prometheus_user_rules" {
  count  = "${var.prometheus_user_rules == "" ? 0 : 1}"
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/rules.yaml"
  source = "${var.prometheus_user_rules}"
  etag   = "${md5(file(var.prometheus_user_rules))}"
}

resource "aws_s3_bucket_object" "idp_metadata" {
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/idp_metadata.xml"
  source = "${var.mellon_idp_metadata_file}"
  etag   = "${md5(file(var.mellon_idp_metadata_file))}"
}

resource "aws_s3_bucket_object" "grafana_prefab_public_tls_cert" {
  count  = "${var.grafana_tls_prefab_ssm_name == "" ? 0 : 1}"
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/grafana.crt"
  source = "${var.grafana_prefab_public_tls_cert}"
  etag   = "${md5(file(var.mellon_idp_metadata_file))}"
}

resource "aws_s3_bucket_object" "cloudwatch_exporter_config" {
  count  = "${var.cloudwatch_exporter_config == "" ? 0 : 1}"
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/cloudwatch_exporter.yml"
  source = "${var.cloudwatch_exporter_config}"
  etag   = "${md5(file(var.cloudwatch_exporter_config))}"
}

resource "aws_s3_bucket_object" "cloudwatch_agent_config" {
  count  = "${var.cloudwatch_agent_config == "" ? 0 : 1}"
  bucket = "${aws_s3_bucket.service_bucket.id}"
  key    = "${var.service_s3_config_prefix}/amazon-cloudwatch-agent.json"
  source = "${var.cloudwatch_agent_config}"
  etag   = "${md5(file(var.cloudwatch_agent_config))}"
}
