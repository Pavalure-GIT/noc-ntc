/**
# Module modules/bundles/aws/vpc_peering version 1.0.0

Create a VPC request based on input parameters

## Requirements

terraform ~> 0.10.4

## Usage
```
* module "vpc_peering" {
*   source 						= "modules/assets/aws/vpc_peering"
*   peer_account_id 			= "${var.peer_account_id}"
*   peer_vpc_id 				= "${var.peer_vpc_id}"
*   local_vpc_id 				= "${var.local_vpc_id}"
*   tag_name_vpc              	= "${var.tag_name_vpc}"
*   tag_name_internet_gateway 	= "${var.tag_name_internet_gateway}"
*   tags                      	= "${module.tags.tags}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}

resource "aws_vpc_peering_connection" "peering_request" {
  peer_owner_id = "${var.peer_account_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.local_vpc_id}"
  auto_accept   = "${var.auto_accept}"
  tags          = "${merge(var.tags, map("Name", var.tag_name_peer))}"
}
