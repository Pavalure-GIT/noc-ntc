
variable "region" {
  default = "eu-west-2"
}

variable "integration_peer_account_id" {
  type = "map"
}

variable "integration_vpc_id" {
  type = "map"
}

variable "integration_cidr_block" {
  type = "map"
}

variable "shared_services_vpc" { 
  type = "string"
  default = "vpc-6dd49604"
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

variable "aws_region" {
  default = "eu-west-2"
}

variable "private_hosted_zone_name" {
  type        = "map"
  description = "Private Hosted Zone name"
}

variable "remote_state_bucket" {
  type        = "map"
  description = "Terraform remote state bucket"
}

variable "integration_hosted_zone_id" {
  type        = "map"
  description = "Integration hosted zone id"
}

variable "workspace" {
  type        = "map"
  description = "Workspace"
}


variable "domain_names_nol" {
  type        = "map"
  description = "NOL Domain names for Certificates"
}

variable "domain_names_ntc" {
  type        = "map"
  description = "NOL Domain names for Certificates"
}

variable "additional_names_nol" {
  type        = "map"
  description = "NOL Additional Domain names for Certificates"
}

variable "additional_names_ntc" {
  type        = "map"
  description = "NOL Additional Domain names for Certificates"
}

locals {

  vpc_id = {
    dev   = "${data.terraform_remote_state.network.preprod_vpc_id}"
    test  = "${data.terraform_remote_state.network.prod_vpc_id}"
    stage = "${data.terraform_remote_state.network.preprod_vpc_id}"
    prod  = "${data.terraform_remote_state.network.prod_vpc_id}"
  },
  route_tables = {
    dev   = "${slice(data.terraform_remote_state.network.preprod_vpc_route_table_ids, 0, 2)}"
    test  = "${slice(data.terraform_remote_state.network.prod_vpc_route_table_ids, 0, 2)}"
    stage = "${slice(data.terraform_remote_state.network.preprod_vpc_route_table_ids, 0, 2)}"
    prod  = "${slice(data.terraform_remote_state.network.prod_vpc_route_table_ids, 0, 2)}"
  }
}