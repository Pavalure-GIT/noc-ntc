data "aws_region" "current" {}

data "aws_caller_identity" "account" {}


data "aws_subnet_ids" "aws-subnet-ids" {
  vpc_id = "${data.terraform_remote_state.network.mgmt_vpc_id}"
}

data "aws_subnet" "subnet1" {
  id = "${data.aws_subnet_ids.aws-subnet-ids.ids[0]}"
}

data "aws_subnet" "subnet2" {
  id = "${data.aws_subnet_ids.aws-subnet-ids.ids[1]}"
}

data "aws_kms_alias" "dwp-generated-key" {
  name = "alias/dwp-kms-generated"
}

data "aws_route53_zone" "route53_zone" {
  name         = "${var.domain_name}"
  private_zone = "${var.domain_is_private}"
}

data "aws_vpc" "vpcs" {
  count = "${length(local.vpc_ids)}"
  id    = "${local.vpc_ids[count.index]}"
}


data "terraform_remote_state" "network" {
  backend = "s3"
  workspace = "${var.network_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/network"
    region = "eu-west-2"
  }
}
