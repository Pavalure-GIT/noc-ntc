resource "aws_autoscaling_group" "app" {
  name = "${var.name}-${terraform.workspace}-asg"
  vpc_zone_identifier = ["${local.private_subnets[terraform.workspace]}"]
  min_size = "${var.asg_min}"

  max_size             = "${var.asg_max}"
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.name}"
  health_check_type    = "ELB"

  tags = ["${
      concat(
      local.asg_tags,
      list(
        map(
          "key", "Name",
          "value", "NOL Kong API GW Autoscaling group - ${terraform.workspace}",
          "propagate_at_launch", true
          )
        )
      )
    }"]
}

data "template_file" "kong_userdata" {

  template = <<EOF
#!/bin/bash
${file("./kong-ami.tpl")}
${file(format("%s/assets/prom_user_data.sh", path.module))}
EOF

  vars {
    pg_user     = "${aws_db_instance.default_nolntc_nol.username}"
    pg_password = "${aws_db_instance.default_nolntc_nol.password}"
    pg_database = "${aws_db_instance.default_nolntc_nol.name}"
    pg_endpoint = "${aws_db_instance.default_nolntc_nol.address}"
    secret      = "${data.aws_ssm_parameter.kongpassword.value}"
    gateway                    = "http://${aws_alb.apigw_nol.dns_name}:8001/apis"
    name                       = "kongNOL"    
    upstream_url               = "https://${data.terraform_remote_state.nol.nol_alb_dns}"
    env         = "${var.network_workspace[terraform.workspace]}"
    config_idpRedirectEndpoint = "https://fedsvcs.linkgtm.gpn.gov.uk/adfs/ls/"
    // Below for Prometheus config
    SQUID_PROXY   = "${data.terraform_remote_state.network.squid_private_ip}"
    configuration = "${var.configuration}"
    repository_bucket = "${var.repository_bucket}"
    dwp-ansible-prometheus-node-exporter-version = "${var.dwp-ansible-prometheus-node-exporter-version}"
  }
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix          = "${var.name}-${terraform.workspace}-nol-ecs"
  security_groups      = ["${aws_security_group.instance.id}"]
  image_id             = "${var.ami_image_id[terraform.workspace]}"
  user_data            = "${data.template_file.kong_userdata.rendered}"
  instance_type        = "${var.ec2_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.apigw.id}"
  key_name             = "${var.ssh_key_name}"

  lifecycle {
    create_before_destroy = true
  }
}
