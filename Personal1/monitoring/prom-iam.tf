data "template_file" "prom_policy" {

  template = "${file(format("%s/assets/prom_instance_profile_policy.json", path.module))}"

  vars {
    region    = "${data.aws_region.current.name}"
    repository_bucket = "${var.repository_bucket}"
    service_s3_bucket = "${var.service_s3_bucket}"
    service_s3_backup_prefix = "${var.service_s3_backup_prefix}"
    service_s3_config_prefix = "${var.service_s3_config_prefix}"
    account_id = "${data.aws_caller_identity.account.account_id}"
    kms_key_id      = "${data.aws_kms_alias.dwp-generated-key.target_key_id}"
    resources_prefix = "${var.resources_prefix}"
    terraform_workspace = "${terraform.workspace}"
  }
}

resource "aws_iam_role" "prom_ec2_role" {
  name               = "${var.resources_prefix}-prom-${var.iam_role_name}-${var.environment}"
  path               = "/"
  assume_role_policy = "${file(format("%s/assets/assume_role_policy.json", path.module))}"
}

resource "aws_iam_role_policy" "prom_iam_policy" {
  name   = "${var.resources_prefix}-prom-${var.iam_policy_name}-${var.environment}"
  role   = "${aws_iam_role.prom_ec2_role.id}"
  policy = "${data.template_file.prom_policy.rendered}"
}

resource "aws_iam_instance_profile" "prom_instance_profile" {
  name = "${var.resources_prefix}-prom-${var.iam_instance_profile_name}-${var.environment}"
  role = "${aws_iam_role.prom_ec2_role.name}"
}
