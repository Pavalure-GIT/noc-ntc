data "template_file" "prom_user_data" {
  template = <<EOF
#!/bin/bash
${var.pre_user_data}
${file(format("%s/assets/common_user_data.sh", path.module))}
${file(format("%s/assets/prom_user_data.sh", path.module))}
${file(format("%s/assets/final_user_data.sh", path.module))}
${var.post_user_data}
EOF

  vars {
    role                  = "prom"
    environment           = "${var.environment}"
    configuration         = "${var.configuration}"
    ansible_rpm_versions  = "${jsonencode(var.ansible_rpm_versions)}"
    repository_bucket     = "${var.repository_bucket}"
    repository_prefix     = "${var.repository_prefix}/${var.environment}"
    common_config         = "${jsonencode(local.common_config)}"
    merged_ansible_prometheus_settings     = "${jsonencode(merge(local.ansible_prometheus_settings,
                                               map("env_name", var.environment),
                                               map("pdu_name", var.pdu_name)))}"
    squid_proxy           = "${data.terraform_remote_state.network.squid_private_ip}"
  }
}

resource "aws_launch_configuration" "prom_launch_configuration" {
  name_prefix   = "${var.resources_prefix}-prom-"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.ec2_key_name}"

  iam_instance_profile = "${aws_iam_instance_profile.prom_instance_profile.arn}"

  security_groups = [
    "${aws_security_group.prom_app_sg.id}",
    "${aws_security_group.common_app_sg.id}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_file.prom_user_data.rendered}"
}

resource "aws_autoscaling_group" "prom_autoscaling" {
  name_prefix = "${aws_launch_configuration.prom_launch_configuration.name}"

  launch_configuration = "${aws_launch_configuration.prom_launch_configuration.id}"

  vpc_zone_identifier = ["${local.private_subnets[terraform.workspace]}"]

  min_size                  = "1"
  max_size                  = "1"
  desired_capacity          = "1"
  health_check_grace_period = "${var.autoscaling_health_grace}"
  default_cooldown          = "${var.default_cooldown}"

  load_balancers = [
    "${aws_elb.prom_elb.id}"
  ]

  health_check_type = "ELB"

  lifecycle {
    create_before_destroy = true
  }
  tags = "${var.prom_asg_tags}"
}

resource "aws_ebs_volume" "prom_data_1" {
  availability_zone = "${data.aws_subnet.subnet1.availability_zone}"
  size = "${var.prom_data_disk_size}"
  tags = "${var.prom_tags}"
}

resource "aws_ebs_volume" "prom_data_2" {
  availability_zone = "${data.aws_subnet.subnet2.availability_zone}"
  size = "${var.prom_data_disk_size}"
  tags = "${var.prom_tags}"
}
