deploy_region = "eu-west-2"

env_name = "${terraform.workspace}"

rds_user = "kong"

public_subnet_ids = "${local.public_subnets[terraform.workspace]}"
private_subnet_ids = "${local.private_subnets[terraform.workspace]}"
vpc_id = "${local.vpc_id}"
vpc_cidr = "${local.vpc_cidr}"

remote_state_bucket = {
  dev   = "dwp-nolntc-dev-terraform-states"
  test  = "dwp-nolntc-dev-terraform-states"
  stage = "dwp-nolntc-prod-terraform-states"
  prod  = "dwp-nolntc-prod-terraform-states"
}

name = "api-gw-kong-nol"

asg_min = 1
asg_max = 1

domain_cert_arn = {
  dev = "arn:aws:acm:eu-west-2:677218555239:certificate/0909518f-a66a-4dcb-a083-18b946cb7cd7"
  test  = "arn:aws:acm:eu-west-2:677218555239:certificate/0909518f-a66a-4dcb-a083-18b946cb7cd7"
  stage = "arn:aws:acm:eu-west-2:923609091913:certificate/f15bf08d-7458-4112-98c2-9e11f2364e62"
  prod  = "arn:aws:acm:eu-west-2:923609091913:certificate/f15bf08d-7458-4112-98c2-9e11f2364e62"
}

dwp-ansible-prometheus-node-exporter-version = "0.48235.0"

ami_image_id = {
  dev = "ami-0e77476149060c585"
  test = "ami-0e77476149060c585"
  stage = "ami-09b03f4415ba5c5e9"
  prod = "ami-09b03f4415ba5c5e9"
}