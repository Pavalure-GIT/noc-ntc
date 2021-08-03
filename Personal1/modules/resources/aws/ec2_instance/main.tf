/**
# Module modules/resources/aws/ec2_instance version 1.0.0

Create a EC2 instance.

## Description

The EC2 instance generated will be based on the AMI set in the variable `ami_id` and optionally instantiated
with the data provided by the variable `user_data`.

## Requirements

terraform ~> 0.10.4

## Usage

```
* module "instance" {
*   source = "modules/resources/aws/ec2_instance"
*
*   ami_id                 = "${var.ami_id}"
*   instance_type          = "${var.instance_type}"
*   vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
*   subnet_id              = "${var.subnet_id}"
*   ebs_optimized          = "${var.ebs_optimized}"
*   iam_instance_profile   = "${var.iam_instance_profile}"
*   key_name               = "${var.key_name}"
*
*   user_data = "${file("userdata.sh"}"
*
*   tag_name      = "${var.tag_name}"
*   instance_tags = "${var.instance_tags}"
*   volume_tags   = "${var.volume_tags}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}

resource "aws_instance" "instance" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  subnet_id              = "${var.subnet_id}"
  ebs_optimized          = "${var.ebs_optimized}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  key_name               = "${var.key_name}"

  user_data = "${var.user_data}"

  tags        = "${merge(var.volume_tags, map("Name", var.tag_name))}"
  volume_tags = "${merge(var.instance_tags, map("Name", var.tag_name))}"
}
