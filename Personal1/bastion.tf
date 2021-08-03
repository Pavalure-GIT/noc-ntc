resource "aws_launch_configuration" "bastion_instance" {
  name_prefix = "nolntc-bastion-${terraform.workspace}"
  image_id    = "${var.bastion_ami_id[terraform.workspace]}"
  key_name    = "NOLNTCBastionKey"
  instance_type        = "${var.instance_type}"
  security_groups = ["${aws_security_group.bastion_sg.id}"]  
  user_data = "${data.template_file.bastionuserdata.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion_instance_profile.id}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "bastion_asg" {
  name             = "NOLNTCBastionAutoScalingGroup - ${terraform.workspace}"
  min_size         = "${var.bastion_asg_min}"
  max_size         = "${var.bastion_asg_max}"
  desired_capacity = 1
  health_check_type = "EC2"
  health_check_grace_period = "300"
  vpc_zone_identifier = ["${module.vpc_mgmt_subnets.subnet_ids[0]}"]
  launch_configuration = "${aws_launch_configuration.bastion_instance.name}"
  depends_on = [
    "aws_launch_configuration.bastion_instance"
  ]
  tags = ["${
      concat(
      local.asg_tags,
      list(
        map(
          "key", "Name",
          "value", "NOLNTCBastionAutoScalingGroup - ${terraform.workspace}",
          "propagate_at_launch", true
          )
        )
      )
    }"
  ]

}

# IAM Roles
resource "aws_iam_role" "bastion_role" {
  name = "nolntc-bastion-role-${terraform.workspace}"
  assume_role_policy = "${file(format("%s/assets/assume_role.json", path.module))}"
}

resource "aws_iam_role_policy" "bastion_policy" {
  policy = "${file(format("%s/assets/policy.json", path.module))}"
  role = "${aws_iam_role.bastion_role.id}"
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  role = "${aws_iam_role.bastion_role.name}"
  name = "nolntc-bastion-${terraform.workspace}"
}

resource "aws_security_group" "bastion_sg" {
  name   = "nolntc-bastion-sg"
  vpc_id      = "${module.vpc_mgmt.vpc_id}"
  tags   = "${merge(module.tags.tags, map("Name", "NOLNTC bastion_sg"))}"

  #Allow Access from Application Support PCs via Zscaler
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  #Allow Access to management, staging and production vpcs
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["${module.vpc_preprod.vpc_cidr_block}","${module.vpc_mgmt.vpc_cidr_block}","${module.vpc_prod.vpc_cidr_block}"]
  }
}

data "template_file" "bastionuserdata" {
  template = "${file("${path.module}/assets/bastion-userdata.tpl")}"
  vars {
    private_key       = "${data.aws_ssm_parameter.bastion_key.value}"
    PROXY_PORT        = "3128"
    PROXY_HOST        = "${var.squid_ip[terraform.workspace]}"
    CW_CONFIG         = "/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
    CW_AGENT_URI      = "https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest"
    CW_AGENT_ZIP_FILE = "AmazonCloudWatchAgent.zip"
    LOG_GROUP_NAME    = "HCSBastion"
  }
}