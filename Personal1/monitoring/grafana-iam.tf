data "template_file" "grafana_policy" {
  template = "${file(format("%s/assets/grafana_instance_profile_policy.json", path.module))}"

  vars {
    repository_bucket = "${var.repository_bucket}"
    service_s3_bucket = "${var.service_s3_bucket}"
    service_s3_backup_prefix = "${var.service_s3_backup_prefix}"
    service_s3_config_prefix = "${var.service_s3_config_prefix}"
    account_id = "${data.aws_caller_identity.account.account_id}"
    kms_key_id = "${var.ami_kms_key_id}"
  }
}

data "template_file" "grafana_policy_ssm" {
  template = "${file(format("%s/assets/grafana_ssm_instance_profile_policy.json", path.module))}"

  vars {
    region    = "${data.aws_region.current.name}"
    account_id = "${data.aws_caller_identity.account.account_id}"
    param_name = "${var.grafana_tls_prefab_ssm_name}"
    kms_key_id = "${data.aws_kms_alias.dwp-generated-key.target_key_id}"
    }
}

resource "aws_iam_role" "grafana_ec2_role" {
  name               = "${var.resources_prefix}-grafana-${var.iam_role_name}-${var.environment}"
  path               = "/"
  assume_role_policy = "${file(format("%s/assets/assume_role_policy.json", path.module))}"
}

resource "aws_iam_role_policy" "grafana_iam_policy" {
  name   = "${var.resources_prefix}-grafana-${var.iam_policy_name}-${var.environment}"
  role   = "${aws_iam_role.grafana_ec2_role.id}"
  policy = "${data.template_file.grafana_policy.rendered}"
}

resource "aws_iam_role_policy" "grafana_iam_policy_ssm" {
  count  = "${var.grafana_tls_prefab_ssm_name == "" ? 0 : 1}"
  name   = "${var.resources_prefix}-grafana-${var.iam_policy_name}-ssm-${var.environment}"
  role   = "${aws_iam_role.grafana_ec2_role.id}"
  policy = "${data.template_file.grafana_policy_ssm.rendered}"
}

resource "aws_iam_instance_profile" "grafana_instance_profile" {
  name = "${var.resources_prefix}-grafana-${var.iam_instance_profile_name}-${var.environment}"
  role = "${aws_iam_role.grafana_ec2_role.name}"
}
