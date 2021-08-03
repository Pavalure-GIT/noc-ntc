/**
# Module modules/bundles/aws/security_group version 1.0.0

Create a single security group with associated rules for ingress and egress.

## Description

The rules for ingress and egress can be specified in arrays:

* * ingress_cidrs (prefix for ingress rules based on CIDR blocks)
*   * cidr_blocks (single block not a list, see example below)
*   * from_port
*   * to_port
*   * protocol
*
* * ingress_sgs (prefix for ingress rules based on security group sources)
*   * source
*   * from_port
*   * to_port
*   * protocol
*
* * egress_cidrs (prefix for egress rules based on CIDR blocks)
*   * cidr_blocks (single block not a list, see example below)
*   * from_port
*   * to_port
*   * protocol
*
* * egress_sgs (prefix for egress rules based on security group sources)
*   * source
*   * from_port
*   * to_port
*   * protocol

The data must be ordered for association. See the _Usage_ for an example.

## Requirements

terraform ~> 0.10.4

## Usage

For instance, we want to create a security group having

* * ingress rule limited to CIDR block 1.2.3.4/32 on the port TCP:80
* * ingress rule limited to CIDR block 1.2.3.5/32 on the port TCP:81
* * ingress rule limited to security group sg-0a34b163 on the port UDP:82
* * egress rule allowing all traffic

```
* module "security_group" {
*   source = "modules/assets/aws/security_group"
*   vpc_id = "${var.vpc}"
*
*   ingress_cidr_count = 2
*   ingress_cidr_blocks = ["1.2.3.4/32", "1.2.3.5/32"]
*   ingress_cidr_ports = [80, 81]
*   ingress_cidr_protocols = ["tcp", "tcp"]
*
*   ingress_sg_count = 1
*   ingress_sg_sources = ["sg-0a34b163"]
*   ingress_sg_ports = [82]
*   ingress_sg_protocols = ["udp"]
*
*   egress_cidr_count = 1
*   egress_cidr_blocks = ["0.0.0.0/0"]
*   egress_cidr_ports = ["0"]
*   egress_cidr_protocols = ["-1"]
*
*   tag_name = "${var.tag_name}"
*   tags     = "${var.tags}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}

resource "aws_security_group" "security_group" {
  name   = "${var.tag_name}"
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", var.tag_name))}"
}
