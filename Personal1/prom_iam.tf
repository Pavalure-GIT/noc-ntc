# Policy for yum to grab prometheus exporter + updates from hcs's s3 bucket
data "template_file" "prom_policy" {
  template = "${file(format("%s/assets/prom_instance_profile_policy.json", path.module))}"

  vars {
    repository_bucket = "${var.repository_bucket}"
  }
}

resource "aws_iam_role_policy" "prom_iam_policy" {
  name   = "ntc_ecs_prom_iam_policy-${terraform.workspace}"
  role   = "${aws_iam_role.ecsInstanceRole.id}"
  policy = "${data.template_file.prom_policy.rendered}"
}