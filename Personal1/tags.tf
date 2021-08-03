locals {
  common_asg_tags = [
    {
      key                 = "Environment"
      value               = "${terraform.workspace}"
      propagate_at_launch = true
    },
    {
      key                 = "Costcode"
      value               = "${var.tag_costcode}"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "${var.tag_owner}"
      propagate_at_launch = true
    },
    {
      key                 = "Persistence"
      value               = "True"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "monitoring"
      propagate_at_launch = true
    },
  ]

  prom_unique_asg_tags = [
    {
      key                 = "Role"
      value               = "prometheus"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.resources_prefix}-prom-${terraform.workspace}"
      propagate_at_launch = true
    },
  ]

  grafana_unique_asg_tags = [
    {
      key                 = "Role"
      value               = "grafana"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.resources_prefix}-grafana-${terraform.workspace}"
      propagate_at_launch = true
    },
  ]

  alertmanager_unique_asg_tags = [
    {
      key                 = "Role"
      value               = "alertmanager"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.resources_prefix}-alertmanager-${terraform.workspace}"
      propagate_at_launch = true
    },
  ]

  prom_asg_tags         = "${concat(local.common_asg_tags,local.prom_unique_asg_tags)}"
  grafana_asg_tags      = "${concat(local.common_asg_tags,local.grafana_unique_asg_tags)}"
  alertmanager_asg_tags = "${concat(local.common_asg_tags,local.alertmanager_unique_asg_tags)}"

  common_tags = {
    Environment = "${terraform.workspace}"
    Costcode    = "${var.tag_costcode}"
    Owner       = "${var.tag_owner}"
  }

  common_sg_tags = "${merge(local.common_tags, map("Name", "${var.resources_prefix}-common-${terraform.workspace}"))}"

  prom_tags         = "${merge(local.common_tags, map("Name", "${var.resources_prefix}-prom-${terraform.workspace}"))}"
  grafana_tags      = "${merge(local.common_tags, map("Name", "${var.resources_prefix}-grafana-${terraform.workspace}"))}"
  alertmanager_tags = "${merge(local.common_tags, map("Name", "${var.resources_prefix}-alertmanager-${terraform.workspace}"))}"
}
