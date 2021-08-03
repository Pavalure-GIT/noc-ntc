# Internal Peering to local Management VPC

module "prod_to_mgmt_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${data.aws_caller_identity.current.account_id}"
  peer_vpc_id     = "${module.vpc_prod.vpc_id}"
  local_vpc_id    = "${module.vpc_mgmt.vpc_id}"
  auto_accept     = "true"
  tag_name_peer   = "${var.tag_names_peer_to_prod[terraform.workspace]}"
  tags            = "${module.tags.tags}"
}

module "preprod_to_mgmt_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${data.aws_caller_identity.current.account_id}"
  peer_vpc_id     = "${module.vpc_preprod.vpc_id}"
  local_vpc_id    = "${module.vpc_mgmt.vpc_id}"
  auto_accept     = "true"
  tag_name_peer   = "${var.tag_names_peer_to_preprod[terraform.workspace]}"
  tags            = "${module.tags.tags}"
}



# EXTERNAL PEERING TO SHARED VPCS NOT APPLICABLE FOR DEV


# External Peering to shared VPCs

module "mgmt_to_network_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.network_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.network_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_mgmt.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_network}"
  tags            = "${module.tags.tags}"
}

module "prod_to_network_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.network_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.network_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_prod.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_network}"
  tags            = "${module.tags.tags}"
}

module "preprod_to_network_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.network_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.network_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_preprod.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_network}"
  tags            = "${module.tags.tags}"
}

module "mgmt_to_ss_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.ss_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.ss_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_mgmt.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_ss}"
  tags            = "${module.tags.tags}"
}

module "prod_to_ss_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.ss_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.ss_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_prod.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_ss}"
  tags            = "${module.tags.tags}"
}

module "preprod_to_ss_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.ss_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.ss_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_preprod.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_ss}"
  tags            = "${module.tags.tags}"
}

module "mgmt_to_management_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.management_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.management_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_mgmt.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_management}"
  tags            = "${module.tags.tags}"
}

module "prod_to_management_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.management_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.management_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_prod.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_management}"
  tags            = "${module.tags.tags}"
}

module "preprod_to_management_vpc_peering" {
  source          = "./modules/bundles/aws/vpc_peering"
  peer_account_id = "${var.management_account_ids[terraform.workspace]}"
  peer_vpc_id     = "${var.management_vpc_ids[terraform.workspace]}"
  local_vpc_id    = "${module.vpc_preprod.vpc_id}"
  auto_accept     = "false"
  tag_name_peer   = "${var.tag_name_peer_management}"
  tags            = "${module.tags.tags}"
}
