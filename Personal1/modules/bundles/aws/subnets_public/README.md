# Module modules/bundles/aws/subnets_public version 1.0.0

Generate an array of public subnets and associated routing tables connected to an internet gateway sized to the value
of the count variable.

## Description

Among the other variables, this module in input requires:

- the number of subnet to create
- a list of CIDR blocks
- a list of availabity zones
- a list of routing destination CIDR blocks
- a list of tag names for the subnet
- a list of tag names for the route table

The lists must be assigned in the belonging order. Example if we want to generate 4 private subnets:

- 10.0.0.0/24 in AZ eu-west-2a tagged subnet-app-2a
- 10.0.1.0/24 in AZ eu-west-2b tagged subnet-app-2b
- 10.0.2.0/24 in AZ eu-west-2a tagged subnet-elb-2a
- 10.0.3.0/24 in AZ eu-west-2b tagged subnet-elb-2b

## Requirements

terraform ~> 0.10.4

## Usage

```
module "subnets" {
  source = "modules/assets/aws/subnets_private"

  vpc_id = "${var.vpc_id}"

  count = 4
  cidr_blocks = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
  availability_zones = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2a",
    "eu-west-2b"
  ]
  destination_cidr_blocks = [
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0"
  ]
  tag_name_subnets = [
    "subnet-app-2a",
    "subnet-app-2b",
    "subnet-elb-2a",
    "subnet-elb-2b"
  ]
  tag_name_route_tables = [
    "rt-app-2a",
    "rt-app-2b",
    "rt-elb-2a",
    "rt-elb-2b"
  ]

  tags = "${var.tags}"
}


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability_zones | Availability zone list | list | - | yes |
| cidr_blocks | CIDR block list | list | - | yes |
| count | Number of subnet to create | string | - | yes |
| destination_cidr_blocks | Routing destination CIDR block list | list | - | yes |
| internet_gateway | Internet gateway | string | - | yes |
| map_public_ip_on_launch | True if the instances into the subnet should be assigned a public IP address | string | `true` | no |
| tag_name_route_tables | Tag Name list for the route tables | list | - | yes |
| tag_name_subnets | Tag Name list for the subnets | list | - | yes |
| tags | Required tags | map | - | yes |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| route_table_ids | List of route table IDs |
| subnet_ids | List of subnet IDs |

