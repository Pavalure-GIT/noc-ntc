# Module modules/resources/aws/ec2_instance version 1.0.0

Create a EC2 instance.

## Description

The EC2 instance generated will be based on the AMI set in the variable `ami_id` and optionally instantiated
with the data provided by the variable `user_data`.

## Requirements

terraform ~> 0.10.4

## Usage

```
module "instance" {
  source = "modules/resources/aws/ec2_instance"

  ami_id                 = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  subnet_id              = "${var.subnet_id}"
  ebs_optimized          = "${var.ebs_optimized}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  key_name               = "${var.key_name}"

  user_data = "${file("userdata.sh"}"

  tag_name      = "${var.tag_name}"
  instance_tags = "${var.instance_tags}"
  volume_tags   = "${var.volume_tags}"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami_id | AMI ID to use for generating the instance | string | - | yes |
| ebs_optimized | Whether the instance has been optimized for the use of EBS | string | `false` | no |
| iam_instance_profile | IAM instance profile set for this instance | string | `` | no |
| instance_tags | Tags for the EC2 instance | map | - | yes |
| instance_type | Type of instance to use | string | - | yes |
| key_name | Key pair to use | string | - | yes |
| subnet_id | Subnet ID | string | - | yes |
| tag_name | Tag name | string | - | yes |
| user_data | The user data to provide when launching the instance | string | `` | no |
| volume_tags | Tags for the EC2 instance | map | - | yes |
| vpc_security_group_ids | Security groups IDs | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the instance |
| private_ip | Private IP assigned to the instance |
| public_ip | Public IP assigned to the instance |

