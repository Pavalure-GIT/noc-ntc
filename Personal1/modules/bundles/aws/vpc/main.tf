/**
# Module modules/bundles/aws/vpc version 1.0.0

Create a VPC with associated an internet gateway.

## Requirements

terraform ~> 0.10.4

## Usage
```
* module "vpc" {
*   source   = "modules/assets/aws/vpc"
*   cidr_block = "${var.vpc_cidr}"
*
*   tag_name_vpc              = "${var.tag_name_vpc}"
*   tag_name_internet_gateway = "${var.tag_name_internet_gateway}"
*   tags                      = "${module.tags.tags}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  tags                 = "${merge(var.tags, map("Name", var.tag_name_vpc))}"
}
