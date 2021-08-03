// General config

variable "pdu_name" {
  description = "What is the name of this PDU?  e.g. cis, integr, dcbt"
}

variable "configuration" {
  description = "Configuration tool. Tools available: ansible"
  default     = "ansible"
}

variable "ansible_rpm_versions" {
  description = "Declare the versions of dependent RPM packages which will be installed"

  type = "map"

  default = {
    dwp-ansible-grafana-saml                   = "1.0.14"
    dwp-ansible-prometheus                     = "0.124772.0"
    dwp-ansible-prometheus-alertmanager        = "0.126493.0"
    dwp-ansible-prometheus-blackbox-exporter   = "0.48214.0"
    dwp-ansible-prometheus-cloudwatch-exporter = "1.0.5"
    dwp-ansible-prometheus-node-exporter       = "0.48235.0"
    dwp-ansible-prometheus-pushgateway         = "0.48252.0"
    dwp-ansible-cloudwatch-agent               = "0.53307.0"
  }
}

variable "resources_prefix" {
  description = "Prefix to identify the resources"
  default     = "mon"
}

variable "environment" {
  description = "Environment label"
}

# variable "vpc_ids" {
#   description = "List of VPC IDs to be monitored"
#   type        = "list"
# }

// Subnets configuration

# variable "ec2_subnet_ids" {
#   description = "Subnet IDs to be used by EC2 instances"
#   type        = "list"
# }

# variable "elb_subnet_ids" {
#   description = "Subnet IDs to be used by Grafana and Prometheus ELBs"
#   type        = "list"
# }

// Instance configuration

variable "image_id" {
  description = "AMI ID to use for EC2 instances"
  type = "string"
}

variable "ami_kms_key_id" {
  description = "The ID of the KMS key used to encrypt the AMI"
  type = "string"
}

variable "ec2_key_name" {
  description = "Key pair"
}

// CIDR blocks

variable "grafana_ingress_cidr_blocks" {
  description = "Grafana ingress rule CIDR blocks"
  type        = "list"
}

variable "app_sg_cidr_blocks" {
  description = "Prometheus egress rule CIDR blocks"
  type        = "list"

  default = [
    "0.0.0.0/0",
  ]
}

variable "central_prometheus_cidr_blocks" {
  description = "The CIDR blocks that Hybrid Cloud Services central Prometheus will initiate HTTP calls from"
  type        = "list"

  default = [
    "10.84.74.0/23",
  ]
}

// Repository

variable "repository_bucket" {
  description = "Bucket to be used as repository"
  default     = "dwp-cloudservices-hcs-sre-deploy-dev"
}

variable "repository_prefix" {
  description = "Repository key prefix"
  default     = "repository"
}

// Tags

variable "common_sg_tags" {
  description = "Security group tags (map format name/value/propagate_at_launch)"
  type        = "map"
}

variable "prom_asg_tags" {
  description = "Autoscaling group tags (list of maps: format name/value/propagate_at_launch)"
  type        = "list"
}

variable "prom_tags" {
  description = "Security group tags (map format name/value/propagate_at_launch)"
  type        = "map"
}

variable "grafana_asg_tags" {
  description = "Autoscaling group tags (list of maps: format name/value/propagate_at_launch)"
  type        = "list"
}

variable "grafana_tags" {
  description = "Security group tags (map format name/value/propagate_at_launch)"
  type        = "map"
}

variable "alertmanager_asg_tags" {
  description = "Autoscaling group tags (list of maps: format name/value/propagate_at_launch)"
  type        = "list"
}

variable "alertmanager_tags" {
  description = "Security group tags (map format name/value/propagate_at_launch)"
  type        = "map"
}

// IAM resources names

variable "iam_role_name" {
  description = "IAM role name"
  default     = "iam-role"
}

variable "iam_policy_name" {
  description = "IAM policy name"
  default     = "iam-policy"
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  default     = "iam-instance-profile"
}

// DNS

variable "grafana_alt_name" {
  description = "Which hostname to use for grafana if not 'grafana'"
  default     = "grafana"
}

variable "domain_name" {
  description = "Domain name used as parent for grafana"
}

variable "domain_is_private" {
  description = "Is the zone used as parent for grafana private?"
  default     = true
}

// ELBs

variable "prom_elb_name" {
  description = "Prometheus ELB name"
  default     = "prom-elb"
}

variable "grafana_elb_name" {
  description = "Grafana ELB name"
  default     = "grafana-elb"
}

variable "grafana_elb_internal" {
  description = "Is Grafana ELB internal"
  default     = true
}

variable "service_s3_elb_logs_prefix" {
  description = "Grafana ELB S3 key prefix"
  default     = "elb/grafana"
}

variable "elb_healthy_target" {
  description = "Target of the Grafana check"
  default     = "HTTPS:443/health/"
}

variable "elb_logs_bucket" {
  description = "The name of the S3 bucket used to store ELB logs"
  default     = ""
}

variable "elb_logs_interval" {
  description = "ELB access logs publishing interval in minutes"
  default     = 60
}

variable "elb_healthy_threshold" {
  description = "Number of checks before the instance is declared healthy"
  default     = 2
}

variable "elb_unhealthy_threshold" {
  description = "Number of checks before the instance is declared unhealthy"
  default     = 3
}

variable "elb_healthy_timeout" {
  description = "Length of time before the check times out"
  default     = 10
}

variable "elb_healthy_interval" {
  description = "Interval between health checks"
  default     = 15
}

// Other parameters

variable "instance_type" {
  description = "EC2 instance type"
  type = "string"
}

variable "default_cooldown" {
  description = "Minimum number of seconds between autoscaling events"
  default     = 60
}

variable "autoscaling_health_grace" {
  description = "Health grace period for asutoscaling group"
  default     = 600
}

variable "sg_prefix_list_ids" {
  description = "Security group prefix list IDs"
  type        = "list"
  default     = []
}

// Packages to install

variable "install_prometheus" {
  description = "Install Prometheus"
  default     = "yes"
}

variable "install_grafana" {
  description = "Install Grafana"
  default     = "yes"
}

variable "install_alertmanager" {
  description = "Install AlertManager"
  default     = "yes"
}

// Configuration

variable "prometheus_user_config" {
  description = "Full path to custom Prometheus configuration. If empty the default configuration will be applied"
  default     = ""
}

variable "prometheus_alertmanager_user_config" {
  description = "Full path to custom Alertmanager configuration. If empty the default configuration will be applied"
  default     = ""
}

variable "prometheus_alertmanager_recipients" {
  description = "List of email addresses to receive email notifications"
  default     = ""
}

variable "prometheus_alertmanager_slack_url" {
  description = "Slack URL Alertmanager will use to send Slack notifications. If empty no slack endpoint will be configured."
  default     = ""
}

variable "prometheus_alertmanager_slack_channel" {
  description = "Slack channel to which Alertmanager will send Slack notifications."
  default     = ""
}

variable "prometheus_user_rules" {
  description = "Full path to custom Prometheus alerting rules. If empty the default configuration will be applied"
  default     = ""
}

variable "cloudwatch_exporter_config" {
  description = "Full path to Cloudwatch Exporter (Prometheus only) YAML config. If empty the default configuration will be applied"
  default     = ""
}

variable "cloudwatch_agent_config" {
  description = "Full path to Cloudwatch Agent (on each instance) JSON config. If empty the default configuration will be applied"
  default     = ""
}

variable "mellon_idp_metadata_file" {
  description = "Full path to IDP metadata file"
}

variable "grafana_prefab_public_tls_cert" {
  description = "Full path to the PEM certificate for Grafana webserver"
  default     = ""
}

variable "service_s3_bucket" {
  description = "Name of the S3 bucket in which to store configuration files and Grafana backups"
}

variable "service_s3_backup_prefix" {
  description = "Prefix to the backup service S3 bucket"
  default     = "backups"
}

variable "service_s3_config_prefix" {
  description = "Prefix to the backup service S3 bucket"
  default     = "configs"
}

variable "grafana_prometheus_elb_hostname" {
  description = "For production deployments, grafana needs to know how to contact a Prometheus datasource"
  default     = "grafana"
}

variable "grafana_tls_prefab_ssm_name" {
  description = "If using a private TLS key for the Grafana webserver, this is the parameter name in SSM"
  default     = ""
}

variable "grafana_tls_prefab_s3_object" {
  description = "The name of the S3 object at service_s3_bucket/service_s3_config_prefix/ which stores the PEM public certificate for the Grafana webserver"
  default     = ""
}

variable "prom_data_disk_size" {
  description = "Size in gigabytes for the Prometheus EBS persistent data volume"
  default     = "200"
}

variable "pre_user_data" {
  description = "Lines to prepend before all user_data scripts"
  type        = "string"
  default     = ""
}

variable "post_user_data" {
  description = "Lines to append after all user_data scripts"
  type        = "string"
  default     = ""
}

variable remote_state_bucket  {
  type= "map"
  default = {
    dev = "dwp-nolntc-dev-terraform-states"
    test = "dwp-nolntc-dev-terraform-states"
    stage = "dwp-nolntc-prod-terraform-states"
    prod  = "dwp-nolntc-prod-terraform-states"
  }
}

variable "network_workspace" {
  type = "map"

  default = {
    dev   = "nonproduction"
    test  = "nonproduction"
    stage = "production"
    prod  = "production"
  }
}

// Calculated variables

locals {
  elb_logs_bucket = "${var.elb_logs_bucket == "" ? var.service_s3_bucket : var.elb_logs_bucket}"


  vpc_ids = [
    "${data.terraform_remote_state.network.mgmt_vpc_id}", 
    "${data.terraform_remote_state.network.preprod_vpc_id}",
    "${data.terraform_remote_state.network.prod_vpc_id}", 
  ]

  private_subnets = {
    dev   = "${slice(data.terraform_remote_state.network.mgmt_vpc_subnet_ids, 0, 2)}"
    test  = "${slice(data.terraform_remote_state.network.mgmt_vpc_subnet_ids, 0, 2)}"
    stage = "${slice(data.terraform_remote_state.network.mgmt_vpc_subnet_ids, 0, 2)}"
    prod  = "${slice(data.terraform_remote_state.network.mgmt_vpc_subnet_ids, 0, 2)}"
  }

  common_config = {
    cloudwatch_agent_config_s3_bucket = "${var.service_s3_bucket}"
    cloudwatch_agent_config_s3_path = "${var.cloudwatch_agent_config == "" ? "" : format("%s/amazon-cloudwatch-agent.json", var.service_s3_config_prefix)}"
  }

  ansible_prometheus_settings = {
    prometheus_service_s3_bucket = "${var.service_s3_bucket}"
    prometheus_user_config_path = "${var.prometheus_user_config == "" ? "" : format("%s/prometheus.yaml", var.service_s3_config_prefix)}"
    prometheus_user_rules_path = "${var.prometheus_user_rules == "" ? "" : format("%s/rules.yaml", var.service_s3_config_prefix)}"
    prometheus_data_volume_name_tag = "${var.resources_prefix}-prom-${terraform.workspace}"

    prometheus_cloudwatch_exporter_s3_bucket = "${var.service_s3_bucket}"
    prometheus_cloudwatch_exporter_config = "${var.cloudwatch_exporter_config == "" ? "" : format("%s/cloudwatch_exporter.yml", var.service_s3_config_prefix)}"
  }

  ansible_alertmanager_settings = {
    prometheus_alertmanager_service_s3_bucket = "${var.service_s3_bucket}"
    prometheus_alertmanager_user_config_path = "${var.prometheus_alertmanager_user_config == "" ? "" : format("%s/alertmanager.yaml", var.service_s3_config_prefix)}"
    prometheus_alertmanager_recipients = "${var.prometheus_alertmanager_recipients}"
    prometheus_alertmanager_slack_url = "${var.prometheus_alertmanager_slack_url}"
    prometheus_alertmanager_slack_channel = "${var.prometheus_alertmanager_slack_channel}"
  }

  grafana_config = {
    grafana_fqdn = "${var.grafana_alt_name}.${var.domain_name}"
    grafana_prometheus_elb_hostname = "${aws_elb.prom_elb.dns_name}"
    // Flipped to use alias.name as dns is not resolving correctly...
//    grafana_prometheus_elb_hostname = "${aws_route53_record.prom.fqdn}"
    mellon_idp_metadata_download_method = "s3"
    grafana_service_s3_bucket = "${var.service_s3_bucket}"
    mellon_idp_metadata_file = "${var.service_s3_config_prefix}/idp_metadata.xml"
    grafana_backup_s3_prefix = "${var.service_s3_backup_prefix}"
    grafana_tls_cert_mode = "${var.grafana_tls_prefab_ssm_name == "" ? "selfsign" : "prefab"}"
    grafana_tls_prefab_s3_prefix = "${var.service_s3_config_prefix}"
    grafana_tls_prefab_s3_bucket = "${var.service_s3_bucket}"
    grafana_tls_prefab_ssm_name = "${var.grafana_tls_prefab_ssm_name}"
  }

}
