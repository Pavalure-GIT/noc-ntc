#### Creation of subnets for the Management VPC
# Defaults for subnet CIDR ranges
locals {
  vmsa2a = "${var.vpc_mgmt_subnet_access_2a_block == "" ? cidrsubnet(var.vpc_mgmt_cidr[terraform.workspace], 2, 0) : var.vpc_mgmt_subnet_access_2a_block}"
  vmsa2b = "${var.vpc_mgmt_subnet_access_2b_block == "" ? cidrsubnet(var.vpc_mgmt_cidr[terraform.workspace], 2, 1) : var.vpc_mgmt_subnet_access_2b_block}"
  vmss2a = "${var.vpc_mgmt_subnet_service_2a_block == "" ? cidrsubnet(var.vpc_mgmt_cidr[terraform.workspace], 2, 2) : var.vpc_mgmt_subnet_service_2a_block}"
  vmss2b = "${var.vpc_mgmt_subnet_service_2b_block == "" ? cidrsubnet(var.vpc_mgmt_cidr[terraform.workspace], 2, 3) : var.vpc_mgmt_subnet_service_2b_block}"
}

# Creation of subnets and route tables
module "vpc_mgmt_subnets" {
  source = "./modules/bundles/aws/subnets_private"
  vpc_id = "${module.vpc_mgmt.vpc_id}"
  count  = 4

  cidr_blocks = [
    "${local.vmsa2a}",
    "${local.vmsa2b}",
    "${local.vmss2a}",
    "${local.vmss2b}",
  ]

  availability_zones = [
    "${var.availability_zones[0]}",
    "${var.availability_zones[1]}",
    "${var.availability_zones[0]}",
    "${var.availability_zones[1]}",
  ]

  tag_name_subnets = [
    "subnet-access-2a",
    "subnet-access-2b",
    "subnet-service-2a",
    "subnet-service-2b",
  ]

  tag_name_route_tables = [
    "rt-access-2a",
    "rt-access-2b",
    "rt-service-2a",
    "rt-service-2b",
  ]

  tags = "${module.tags.tags}"
}

# Creation of routes
module "vpc_mgmt_routes" {
  source = "./modules/bundles/aws/route"
  count  = 10

  destination_cidr_blocks = [
    "${var.vpc_prod_cidr[terraform.workspace]}",
    "${var.vpc_prod_cidr[terraform.workspace]}",
    "${var.vpc_preprod_cidr[terraform.workspace]}",
    "${var.vpc_preprod_cidr[terraform.workspace]}",
    "${var.network_cidr_blocks[terraform.workspace]}",
    "${var.network_cidr_blocks[terraform.workspace]}",
    "${var.ss_cidr_blocks[terraform.workspace]}",
    "${var.ss_cidr_blocks[terraform.workspace]}",
    "${var.management_cidr_blocks[terraform.workspace]}",
    "${var.management_cidr_blocks[terraform.workspace]}",
  ]

  route_table_ids = [
    "${module.vpc_mgmt_subnets.route_table_ids[0]}",
    "${module.vpc_mgmt_subnets.route_table_ids[1]}",
    "${module.vpc_mgmt_subnets.route_table_ids[0]}",
    "${module.vpc_mgmt_subnets.route_table_ids[1]}",
    "${module.vpc_mgmt_subnets.route_table_ids[0]}",
    "${module.vpc_mgmt_subnets.route_table_ids[1]}",
    "${module.vpc_mgmt_subnets.route_table_ids[0]}",
    "${module.vpc_mgmt_subnets.route_table_ids[1]}",
    "${module.vpc_mgmt_subnets.route_table_ids[0]}",
    "${module.vpc_mgmt_subnets.route_table_ids[1]}",
  ]

  vpc_peering_connection_ids = [
    "${module.prod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.prod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.preprod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.preprod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.mgmt_to_network_vpc_peering.peering_connection_id}",
    "${module.mgmt_to_network_vpc_peering.peering_connection_id}",
    "${module.mgmt_to_ss_vpc_peering.peering_connection_id}",
    "${module.mgmt_to_ss_vpc_peering.peering_connection_id}",
    "${module.mgmt_to_management_vpc_peering.peering_connection_id}",
    "${module.mgmt_to_management_vpc_peering.peering_connection_id}",
  ]
}

# Creation of NACLs
//module "vpc_mgmt_nacl" {
//  source = "./modules/bundles/aws/network_acl"
//  vpc_id = "${module.vpc_mgmt.vpc_id}"
//
//  subnet_ids = [
//    "${module.vpc_mgmt_subnets.subnet_ids[0]}",
//    "${module.vpc_mgmt_subnets.subnet_ids[1]}",
//    "${module.vpc_mgmt_subnets.subnet_ids[2]}",
//    "${module.vpc_mgmt_subnets.subnet_ids[3]}",
//  ]
//
//  ingress_count        = 1
//  ingress_rule_actions = ["deny"]
//  ingress_cidr_blocks  = ["0.0.0.0/0"]
//  ingress_from_ports   = ["0"]
//  ingress_to_ports     = ["0"]
//  ingress_protocols    = ["-1"]
//
//  egress_count        = 1
//  egress_rule_actions = ["deny"]
//  egress_cidr_blocks  = ["0.0.0.0/0"]
//  egress_from_ports   = ["0"]
//  egress_to_ports     = ["0"]
//  egress_protocols    = ["-1"]
//
//  tag_name = "${var.tag_name_vpc_mgmt_nacl}"
//  tags     = "${module.tags.tags}"
//}

####

#### Creation of subnets for the Production VPC
# Defaults for subnet CIDR ranges
locals {
  vpsa2a = "${var.vpc_prod_subnet_access_2a_block == "" ? cidrsubnet(var.vpc_prod_cidr[terraform.workspace], 2, 0) : var.vpc_prod_subnet_access_2a_block}"
  vpsa2b = "${var.vpc_prod_subnet_access_2b_block == "" ? cidrsubnet(var.vpc_prod_cidr[terraform.workspace], 2, 1) : var.vpc_prod_subnet_access_2b_block}"
  vpss2a = "${var.vpc_prod_subnet_service_2a_block == "" ? cidrsubnet(var.vpc_prod_cidr[terraform.workspace], 2, 2) : var.vpc_prod_subnet_service_2a_block}"
  vpss2b = "${var.vpc_prod_subnet_service_2b_block == "" ? cidrsubnet(var.vpc_prod_cidr[terraform.workspace], 2, 3) : var.vpc_prod_subnet_service_2b_block}"
}

module "vpc_prod_subnets" {
  source = "./modules/bundles/aws/subnets_private"
  vpc_id = "${module.vpc_prod.vpc_id}"
  count  = 4

  cidr_blocks = [
    "${local.vpsa2a}",
    "${local.vpsa2b}",
    "${local.vpss2a}",
    "${local.vpss2b}",
  ]

  availability_zones = [
    "${var.availability_zones[0]}",
    "${var.availability_zones[1]}",
    "${var.availability_zones[0]}",
    "${var.availability_zones[1]}",
  ]

  tag_name_subnets = [
    "subnet-access-2a",
    "subnet-access-2b",
    "subnet-service-2a",
    "subnet-service-2b",
  ]

  tag_name_route_tables = [
    "rt-access-2a",
    "rt-access-2b",
    "rt-service-2a",
    "rt-service-2b",
  ]

  tags = "${module.tags.tags}"
}

module "vpc_prod_routes" {
  source = "./modules/bundles/aws/route"
  count  = 8

  destination_cidr_blocks = [
    "${var.vpc_mgmt_cidr[terraform.workspace]}",
    "${var.vpc_mgmt_cidr[terraform.workspace]}",
    "${var.network_cidr_blocks[terraform.workspace]}",
    "${var.network_cidr_blocks[terraform.workspace]}",
    "${var.ss_cidr_blocks[terraform.workspace]}",
    "${var.ss_cidr_blocks[terraform.workspace]}",
    "${var.management_cidr_blocks[terraform.workspace]}",
    "${var.management_cidr_blocks[terraform.workspace]}",
  ]

  route_table_ids = [
    "${module.vpc_prod_subnets.route_table_ids[0]}",
    "${module.vpc_prod_subnets.route_table_ids[1]}",
    "${module.vpc_prod_subnets.route_table_ids[0]}",
    "${module.vpc_prod_subnets.route_table_ids[1]}",
    "${module.vpc_prod_subnets.route_table_ids[0]}",
    "${module.vpc_prod_subnets.route_table_ids[1]}",
    "${module.vpc_prod_subnets.route_table_ids[0]}",
    "${module.vpc_prod_subnets.route_table_ids[1]}",
  ]

  vpc_peering_connection_ids = [
    "${module.prod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.prod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.prod_to_network_vpc_peering.peering_connection_id}",
    "${module.prod_to_network_vpc_peering.peering_connection_id}",
    "${module.prod_to_ss_vpc_peering.peering_connection_id}",
    "${module.prod_to_ss_vpc_peering.peering_connection_id}",
    "${module.prod_to_management_vpc_peering.peering_connection_id}",
    "${module.prod_to_management_vpc_peering.peering_connection_id}",
  ]
}

# Creation of NACLs
//module "vpc_prod_nacl" {
//  source = "./modules/bundles/aws/network_acl"
//  vpc_id = "${module.vpc_prod.vpc_id}"
//
//  subnet_ids = [
//    "${module.vpc_prod_subnets.subnet_ids[0]}",
//    "${module.vpc_prod_subnets.subnet_ids[1]}",
//    "${module.vpc_prod_subnets.subnet_ids[2]}",
//    "${module.vpc_prod_subnets.subnet_ids[3]}",
//  ]
//
//  ingress_count        = 1
//  ingress_rule_actions = ["deny"]
//  ingress_cidr_blocks  = ["0.0.0.0/0"]
//  ingress_from_ports   = ["0"]
//  ingress_to_ports     = ["0"]
//  ingress_protocols    = ["-1"]
//
//  egress_count        = 1
//  egress_rule_actions = ["deny"]
//  egress_cidr_blocks  = ["0.0.0.0/0"]
//  egress_from_ports   = ["0"]
//  egress_to_ports     = ["0"]
//  egress_protocols    = ["-1"]
//
//  tag_name = "${var.tag_name_vpc_prod_nacl}"
//  tags     = "${module.tags.tags}"
//}

####

#### Creation of subnets for the PreProduction VPC
# Defaults for subnet CIDR ranges
locals {
  vppsa2a = "${var.vpc_preprod_subnet_access_2a_block == "" ? cidrsubnet(var.vpc_preprod_cidr[terraform.workspace], 2, 0) : var.vpc_preprod_subnet_access_2a_block}"
  vppsa2b = "${var.vpc_preprod_subnet_access_2b_block == "" ? cidrsubnet(var.vpc_preprod_cidr[terraform.workspace], 2, 1) : var.vpc_preprod_subnet_access_2b_block}"
  vppss2a = "${var.vpc_preprod_subnet_service_2a_block == "" ? cidrsubnet(var.vpc_preprod_cidr[terraform.workspace], 2, 2) : var.vpc_preprod_subnet_service_2a_block}"
  vppss2b = "${var.vpc_preprod_subnet_service_2b_block == "" ? cidrsubnet(var.vpc_preprod_cidr[terraform.workspace], 2, 3) : var.vpc_preprod_subnet_service_2b_block}"
}

module "vpc_preprod_subnets" {
  source = "./modules/bundles/aws/subnets_private"
  vpc_id = "${module.vpc_preprod.vpc_id}"
  count  = 4

  cidr_blocks = [
    "${local.vppsa2a}",
    "${local.vppsa2b}",
    "${local.vppss2a}",
    "${local.vppss2b}",
  ]

  availability_zones = [
    "${var.availability_zones[0]}",
    "${var.availability_zones[1]}",
    "${var.availability_zones[0]}",
    "${var.availability_zones[1]}",
  ]

  tag_name_subnets = [
    "subnet-access-2a",
    "subnet-access-2b",
    "subnet-service-2a",
    "subnet-service-2b",
  ]

  tag_name_route_tables = [
    "rt-access-2a",
    "rt-access-2b",
    "rt-service-2a",
    "rt-service-2b",
  ]

  tags = "${module.tags.tags}"
}

module "vpc_preprod_routes" {
  source = "./modules/bundles/aws/route"
  count  = 8

  destination_cidr_blocks = [
    "${var.vpc_mgmt_cidr[terraform.workspace]}",
    "${var.vpc_mgmt_cidr[terraform.workspace]}",
    "${var.network_cidr_blocks[terraform.workspace]}",
    "${var.network_cidr_blocks[terraform.workspace]}",
    "${var.ss_cidr_blocks[terraform.workspace]}",
    "${var.ss_cidr_blocks[terraform.workspace]}",
    "${var.management_cidr_blocks[terraform.workspace]}",
    "${var.management_cidr_blocks[terraform.workspace]}",
  ]

  route_table_ids = [
    "${module.vpc_preprod_subnets.route_table_ids[0]}",
    "${module.vpc_preprod_subnets.route_table_ids[1]}",
    "${module.vpc_preprod_subnets.route_table_ids[0]}",
    "${module.vpc_preprod_subnets.route_table_ids[1]}",
    "${module.vpc_preprod_subnets.route_table_ids[0]}",
    "${module.vpc_preprod_subnets.route_table_ids[1]}",
    "${module.vpc_preprod_subnets.route_table_ids[0]}",
    "${module.vpc_preprod_subnets.route_table_ids[1]}",
  ]

  vpc_peering_connection_ids = [
    "${module.preprod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.preprod_to_mgmt_vpc_peering.peering_connection_id}",
    "${module.preprod_to_network_vpc_peering.peering_connection_id}",
    "${module.preprod_to_network_vpc_peering.peering_connection_id}",
    "${module.preprod_to_ss_vpc_peering.peering_connection_id}",
    "${module.preprod_to_ss_vpc_peering.peering_connection_id}",
    "${module.preprod_to_management_vpc_peering.peering_connection_id}",
    "${module.preprod_to_management_vpc_peering.peering_connection_id}",
  ]
}


