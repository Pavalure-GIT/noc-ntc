/**
# main file for standard VPC deploy
*/

# Configure tags that will be applied to all resources
module "tags" {
  source          = "./modules/governance/tags"
  tag_environment = "${var.tag_environments[terraform.workspace]}"
  tag_application = "${var.tag_application}"
  tag_costcode    = "${var.tag_costcode}"
  tag_owner       = "${var.tag_owner}"
}

#### Creation of Management VPC
module "vpc_mgmt" {
  source       = "./modules/bundles/aws/vpc"
  cidr_block   = "${var.vpc_mgmt_cidr[terraform.workspace]}"
  tag_name_vpc = "${var.tag_name_vpc_mgmt}"
  tags         = "${module.tags.tags}"

}

# Removal of all rules from default Security Group
resource "aws_default_security_group" "vpc_mgmt_default_sg" {
  vpc_id = "${module.vpc_mgmt.vpc_id}"
  tags   = "${merge(module.tags.tags, map("Name", "DO NOT EDIT"))}"
}

####

#### Creation of Production VPC
module "vpc_prod" {
  source       = "./modules/bundles/aws/vpc"
  cidr_block   = "${var.vpc_prod_cidr[terraform.workspace]}"
  tag_name_vpc = "${var.tag_names_vpc_prod[terraform.workspace]}"
  tags         = "${module.tags.tags}"
}

# Removal of all rules from default Security Group
resource "aws_default_security_group" "vpc_prod_default_sg" {
  vpc_id = "${module.vpc_prod.vpc_id}"
  tags   = "${merge(module.tags.tags, map("Name", "DO NOT EDIT"))}"
}

####

#### Creation of Pre-Production VPC
module "vpc_preprod" {
  source       = "./modules/bundles/aws/vpc"
  cidr_block   = "${var.vpc_preprod_cidr[terraform.workspace]}"
  tag_name_vpc = "${var.tag_names_vpc_preprod[terraform.workspace]}"
  tags         = "${module.tags.tags}"
}

# Removal of all rules from default Security Group
resource "aws_default_security_group" "vpc_preprod_default_sg" {
  vpc_id = "${module.vpc_preprod.vpc_id}"
  tags   = "${merge(module.tags.tags, map("Name", "DO NOT EDIT"))}"
}

