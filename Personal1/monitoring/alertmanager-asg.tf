data "template_file" "alertmanager_user_data" {
  template = <<EOF
#!/bin/bash
${var.pre_user_data}
${file(format("%s/assets/common_user_data.sh", path.module))}
${file(format("%s/assets/alertmanager_user_data.sh", path.module))}
${file(format("%s/assets/final_user_data.sh", path.module))}
${var.post_user_data}
EOF

  vars {
    role                 = "alertmanager"
    environment          = "${var.environment}"
    configuration        = "${var.configuration}"
    ansible_rpm_versions = "${jsonencode(var.ansible_rpm_versions)}"
    repository_bucket    = "${var.repository_bucket}"
    repository_prefix    = "${var.repository_prefix}/${var.environment}"
    common_config        = "${jsonencode(local.common_config)}"
    squid_proxy          = "${data.terraform_remote_state.network.squid_private_ip}"
    merged_ansible_alertmanager_settings     = "${jsonencode(merge(local.ansible_alertmanager_settings,
                                               map("env_name", var.environment),
                                               map("pdu_name", var.pdu_name)))}"

  }
}

resource "aws_launch_configuration" "alertmanager_launch_configuration" {
  name_prefix          = "${var.resources_prefix}-alert-"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.ec2_key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.alertmanager_instance_profile.arn}"

  security_groups      = [
    "${aws_security_group.alertmanager_app_sg.id}",
    "${aws_security_group.common_app_sg.id}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  user_data            = "${data.template_file.alertmanager_user_data.rendered}"
}

resource "aws_autoscaling_group" "alertmanager_autoscaling" {
  name_prefix               = "${aws_launch_configuration.alertmanager_launch_configuration.name}"

  launch_configuration      = "${aws_launch_configuration.alertmanager_launch_configuration.id}"

  vpc_zone_identifier       = ["${local.private_subnets[terraform.workspace]}"]

  min_size                  = "2"
  max_size                  = "2"
  desired_capacity          = "2"
  health_check_grace_period = "${var.autoscaling_health_grace}"
  default_cooldown          = "${var.default_cooldown}"

  lifecycle {
    create_before_destroy = true
  }

  tags                      = "${var.alertmanager_asg_tags}"
}
