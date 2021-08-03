resource "aws_security_group" "common_app_sg" {
  vpc_id = "${local.vpc_id}"
  tags   = "${var.common_sg_tags}"
  name   = "${var.resources_prefix}-common-${var.environment}"
}

resource "aws_security_group_rule" "common_app_sg_ingress" {
  security_group_id        = "${aws_security_group.common_app_sg.id}"
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.prom_app_sg.id}"
}

resource "aws_security_group" "prom_elb_sg" {
  vpc_id = "${local.vpc_id}"
  name   = "${var.resources_prefix}-prom-elb-${var.environment}"
}

resource "aws_security_group_rule" "prom_elb_sg_ingress" {
  security_group_id        = "${aws_security_group.prom_elb_sg.id}"
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.grafana_app_sg.id}"
}

resource "aws_security_group_rule" "prom_elb_sg_ingress_pushgateway_vpcs" {
  security_group_id = "${aws_security_group.prom_elb_sg.id}"
  type              = "ingress"
  from_port         = 9091
  to_port           = 9091
  protocol          = "tcp"
  cidr_blocks       = ["${data.aws_vpc.vpcs.*.cidr_block}"]
}

resource "aws_security_group_rule" "prom_elb_sg_ingress_central_prom" {
  security_group_id = "${aws_security_group.prom_elb_sg.id}"
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["${var.central_prometheus_cidr_blocks}"]
}

resource "aws_security_group_rule" "prom_elb_sg_egress" {
  security_group_id        = "${aws_security_group.prom_elb_sg.id}"
  type                     = "egress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.prom_app_sg.id}"
}

resource "aws_security_group" "grafana_elb_sg" {
  vpc_id = "${local.vpc_id}"
  name   = "${var.resources_prefix}-grafana-elb-${var.environment}"
}

resource "aws_security_group_rule" "grafana_elb_sg_ingress" {
  security_group_id = "${aws_security_group.grafana_elb_sg.id}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [
    "${var.sg_prefix_list_ids}"]
  cidr_blocks       = [
    "${var.grafana_ingress_cidr_blocks}"]
}

resource "aws_security_group_rule" "grafana_elb_sg_egress" {
  security_group_id        = "${aws_security_group.grafana_elb_sg.id}"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.grafana_app_sg.id}"
}

### Prom app start

resource "aws_security_group" "prom_app_sg" {
  vpc_id = "${local.vpc_id}"
  name   = "${var.resources_prefix}-prom-${var.environment}"
}

resource "aws_security_group_rule" "prom_app_sg_ingress_grafana_elb" {
  security_group_id        = "${aws_security_group.prom_app_sg.id}"
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9091
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.prom_elb_sg.id}"
}

resource "aws_security_group_rule" "prom_app_sg_ingress_pushgw" {
  security_group_id = "${aws_security_group.prom_app_sg.id}"
  type              = "ingress"
  from_port         = 9091
  to_port           = 9091
  protocol          = "tcp"
  self              = "true"
}

resource "aws_security_group_rule" "prom_app_sg_egress" {
  security_group_id = "${aws_security_group.prom_app_sg.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = [
    "${var.app_sg_cidr_blocks}"]
}

### Prom app end
### AlertManager app start

resource "aws_security_group" "alertmanager_app_sg" {
  vpc_id = "${local.vpc_id}"
  name   = "${var.resources_prefix}-alertmanager-${var.environment}"
}

resource "aws_security_group_rule" "alertmanager_app_sg_ingress_grafana_elb" {
  security_group_id        = "${aws_security_group.alertmanager_app_sg.id}"
  type                     = "ingress"
  from_port                = 9093
  to_port                  = 9093
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.prom_app_sg.id}"
}

resource "aws_security_group_rule" "alertmanager_app_sg_ingress_cluster" {
  security_group_id = "${aws_security_group.alertmanager_app_sg.id}"
  type              = "ingress"
  from_port         = 6783
  to_port           = 6783
  protocol          = "tcp"
  self              = "true"
}

resource "aws_security_group_rule" "alertmanager_app_sg_egress" {
  security_group_id = "${aws_security_group.alertmanager_app_sg.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = [
    "${var.app_sg_cidr_blocks}"]
}

### AlertManager app end
### Grafana app start

resource "aws_security_group" "grafana_app_sg" {
  vpc_id = "${local.vpc_id}"
  name   = "${var.resources_prefix}-grafana-${var.environment}"
}

resource "aws_security_group_rule" "grafana_app_sg_ingress_grafana_elb" {
  security_group_id        = "${aws_security_group.grafana_app_sg.id}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.grafana_elb_sg.id}"
}

resource "aws_security_group_rule" "grafana_app_sg_egress" {
  security_group_id = "${aws_security_group.grafana_app_sg.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = [
    "${var.app_sg_cidr_blocks}"]
}
### Grafana app end
