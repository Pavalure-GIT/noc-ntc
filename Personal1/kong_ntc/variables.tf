# Variables that are required for TPT Terraform scripts are defined and
# described here.

variable "ssh_key_name" {
  default     = "nol_key1"
  description = "The ssh key name for instances launched"
}

variable "vpc_cidr" {
  description = "vpc cidr"
}

variable public_subnet_ids {
  description = "Public sunbets"
}

variable private_subnet_ids {
  description = "Private subnets"
}

variable vpc_id {
  description = "VPC for current environment"
}

variable "name" {
  description = "project name"
}


variable "asg_min" {
  description = "Autoscaling group minimum"
}

variable "asg_max" {
  description = "Autoscaling group maximum"
}

variable "ec2_instance_type" {
  default = "t2.small"
  description = "The instance size to use for the application instances"
}

variable "deploy_region" {
  description = "The region for which this stack will be deployed"
}

# Sensitive data so set this via TF_VAR_rds_user environment variable
variable "rds_user" {
  default     = "kong"
  description = "Username for the postgresql server connection."
}

# Sensitive data so set this via TF_VAR_rds_pass environment variable
variable "ami_image_id" {
  type        = "map"
  description = "The image to base the instances from"
}

variable "domain_cert_arn" {
  type        = "map"
  description = "The ARN of ther certificate that is in use for the *.wapm-dev.dwpcloud.uk domain"
}

variable "environments" {
  type = "map"
  default = {
    dev = "NOL-R Development"
    test = "NOL-R Test"
    stage = "NOL-R Staging"
    prod = "NOL-R Production"
  }
}

locals {
  mgmt_vpc_cidr = "${data.terraform_remote_state.network.mgmt_vpc_cidr}"
  vpc_id = {
    dev   = "${data.terraform_remote_state.network.preprod_vpc_id}"
    test  = "${data.terraform_remote_state.network.prod_vpc_id}"
    stage = "${data.terraform_remote_state.network.preprod_vpc_id}"
    prod  = "${data.terraform_remote_state.network.prod_vpc_id}"
  }

  vpc_cidr = {
    dev   = "${data.terraform_remote_state.network.preprod_vpc_cidr}"
    test  = "${data.terraform_remote_state.network.prod_vpc_cidr}"
    stage = "${data.terraform_remote_state.network.preprod_vpc_cidr}"
    prod  = "${data.terraform_remote_state.network.prod_vpc_cidr}"
  }

  private_subnets = {
    dev   = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 0, 2)}"
    test  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 0, 2)}"
    stage = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 0, 2)}"
    prod  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 0, 2)}"
  }

  public_subnets = {
    dev   = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 2, 4)}"
    test  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 2, 4)}"
    stage = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 2, 4)}"
    prod  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 2, 4)}"
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

variable "ntc_workspace" {
  type = "map"

  default = {
    dev   = "dev"
    test  = "test"
    stage = "stage"
    prod  = "prod"
  }
}
variable "monitoring_workspace" {
  type = "map"

  default = {
    dev   = "dev"
    test  = "dev"
    stage = "prod"
    prod  = "prod"
  }
}

variable "remote_state_bucket" {
  type        = "map"
  description = "Terrfaorm remote state bucket"
}

// For downloading Ansible + Prometheus node exporter.
variable "repository_bucket" {
  description = "Bucket to be used as repository"
  default     = "dwp-cloudservices-hcs-sre-deploy-dev"
}

variable "dwp-ansible-prometheus-node-exporter-version" {
  description = "Version of Ansible Prometheus node exporter to use"
  default     = "0.48235.0"
}

variable "configuration" {
  description = "Configuration tool. Tools available: ansible"
  default     = "ansible"
}

locals {
  tags = {
    Application = "NTC View Only / Online"
    Costcode = "10389675"
    Owner = "CMG"
    Environment = "${var.environments[terraform.workspace]}"
  }

  asg_tags = [
    {
      key                 = "Environment"
      value               = "${var.environments[terraform.workspace]}"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "NTC View Only / Online"
      propagate_at_launch = true
    },
    {
      key                 = "Costcode"
      value               = "10389675"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "CMG"
      propagate_at_launch = true
    }
  ]
}
