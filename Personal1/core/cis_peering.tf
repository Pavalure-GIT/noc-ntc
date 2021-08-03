### aws to integration peering for CIS API calls 
resource "aws_vpc_peering_connection" "aws_integration" {
  count = "${var.integration_vpc_id[terraform.workspace] == "" ? 0 : 1}"
  peer_owner_id = "${var.integration_peer_account_id[terraform.workspace]}"
  peer_vpc_id   = "${var.integration_vpc_id[terraform.workspace]}"
  vpc_id        = "${local.vpc_id[terraform.workspace]}"

    tags {
		Name = "VPC peering between Integration VPC and ${terraform.workspace}"
		}
  }

  
// Routes
resource "aws_route" "aws_integration_subnet_a" {
    count = "${var.integration_vpc_id[terraform.workspace] == "" ? 0 : 1}"
    route_table_id            = "${element(local.route_tables[terraform.workspace],0)}"
    destination_cidr_block    = "${var.integration_cidr_block[terraform.workspace]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.aws_integration.id}"
}

resource "aws_route" "aws_integration_subnet_b" {
    count = "${var.integration_vpc_id[terraform.workspace] == "" ? 0 : 1}"
    route_table_id            = "${element(local.route_tables[terraform.workspace],1)}"
    destination_cidr_block    = "${var.integration_cidr_block[terraform.workspace]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.aws_integration.id}"
}

### Creating a route 53 host association

resource "null_resource" "associate_with_remote_hosted_zone" {
  count = "${var.integration_vpc_id[terraform.workspace] == "" ? 0 : 1}"

  provisioner "local-exec" {
    command = "aws route53 associate-vpc-with-hosted-zone --hosted-zone-id ${var.integration_hosted_zone_id[terraform.workspace]} --vpc VPCRegion=${var.aws_region},VPCId=${local.vpc_id[terraform.workspace]}"
  }
}
