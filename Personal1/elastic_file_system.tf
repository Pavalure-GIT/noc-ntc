resource "aws_efs_file_system" "ntc-efs" {
  creation_token = "NTC_EFS_${terraform.workspace}"

  encrypted = true

  tags   = "${merge(local.tags, map("Name", "ntc-efs-${terraform.workspace}"))}"
}


resource "aws_efs_mount_target" "main" {
  count = "2"

  file_system_id = "${aws_efs_file_system.ntc-efs.id}"

  subnet_id = "${element(local.private_subnets[terraform.workspace], count.index)}"

  security_groups = [
    "${aws_security_group.ntc-efs-sg.id}",
  ]
}

# Allow both ingress and egress for port 2049 (NFS)
# such that our instances are able to get to the mount
# target in the AZ.
#
# Additionaly, we set the `cidr_blocks` that are allowed
# such that we restrict the traffic to machines that are
# within the VPC (and not outside).
resource "aws_security_group" "ntc-efs-sg" {
  name        = "efs-mnt-ntc-${terraform.workspace}"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = "${local.vpc_id[terraform.workspace]}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]  
  }

  tags   = "${merge(local.tags, map("Name", "ntc-efs-sg-${terraform.workspace}"))}"
}