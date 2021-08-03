resource "aws_iam_role" "apigw" {
  name = "apigw_role_kong_ntc_${terraform.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "apigw" {
  name = "apigw_profile_kong_ntc_${terraform.workspace}"
  role = "${aws_iam_role.apigw.name}"
}

// Set policy to for yum to grab prometheus exporter + updates from hcs's s3 bucket
data "template_file" "prom_policy" {
  template = "${file(format("%s/assets/prom_instance_profile_policy.json", path.module))}"

  vars {
    repository_bucket = "${var.repository_bucket}"
  }
}

resource "aws_iam_role_policy" "prom_iam_policy" {
  name   = "kong_ntc_prom_iam_policy-${terraform.workspace}"
  role   = "${aws_iam_role.apigw.id}"
  policy = "${data.template_file.prom_policy.rendered}"
}


data "template_file" "kms_policy" {
  template = "${file(format("%s/assets/kms_policy.json", path.module))}"
}

resource "aws_iam_role_policy" "kms_policy" {
  name   = "kong_ntc_kms_iam_policy-${terraform.workspace}"
  role   = "${aws_iam_role.apigw.id}"
  policy = "${data.template_file.kms_policy.rendered}"
}

