# Module modules/bundles/aws/vpc version 1.0.0

Create a VPC with associated an internet gateway.

## Requirements

terraform ~> 0.10.4

## Usage
```
module "vpc" {
  source   = "modules/assets/aws/vpc"
  cidr_block = "${var.vpc_cidr}"

  tag_name_vpc              = "${var.tag_name_vpc}"
  tag_name_internet_gateway = "${var.tag_name_internet_gateway}"
  tags                      = "${module.tags.tags}"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidr_block | VPC CIDR block | string | - | yes |
| enable_dns_hostnames | Enable/disable DNS hostnames in the VPC | string | `true` | no |
| tag_name_internet_gateways | Tag name for the Internet gateway | string | - | yes |
| tag_name_vpc | Tag name for the VPC | string | - | yes |
| tags | Required tags | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| internet_gateway_id | Internet gateway ID |
| vpc_id | VPC ID |

