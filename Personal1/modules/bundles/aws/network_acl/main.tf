/**
# Module modules/bundles/aws/network_acl version 1.0.0

Create a network ACL with associated rules for ingress and egress.

## Description

The rules for ingress and egress can be specified in array:

* - ingress (list of ingress rules)
*   - rule_action
*   - cidr_block
*   - from_port
*   - to_port
*   - protocol
*
* - egress (list of egress rules)
*   - rule_action
*   - cidr_block
*   - from_port
*   - to_port
*   - protocol

The data must be ordered for association.

__The rules generated will be applied in order of definition.__

Please see the __Usage__ for an example.

## Requirements

terraform ~> 0.10.4

## Usage

For instance, we want to create a network ACL having limited to the subnets with ID subnet-1 and subnet-2

* * allow ingress rule limited to CIDR block 1.2.3.4/32 on the port TCP:80
* * deny ingress rule limited to CIDR block 1.2.3.5/32 on the port TCP:81
* * a single egress rule denying all traffic

```
* module "network_acl" {
*   source = "modules/assets/aws/network_acl"
*   vpc_id = "${var.vpc}"
*
*   subnet_ids = ["subnet-1", "subnet-2"]
*
*   ingress_count = 2
*   ingress_rule_actions = ["allow", "deny"]
*   ingress_cidr_blocks = ["1.2.3.4/32", "1.2.3.5/32"]
*   ingress_cidr_ports = [80, 81]
*   ingress_cidr_protocols = ["tcp", "tcp"]
*
*   egress_count = 1
*   egress_rule_actions = ["deny"]
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

resource "aws_network_acl" "network_acl" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${var.subnet_ids}"]
  tags       = "${merge(var.tags, map("Name", var.tag_name))}"
}
