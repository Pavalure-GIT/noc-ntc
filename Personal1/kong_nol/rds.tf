# Create RDS instance
resource "aws_db_instance" "default_nolntc_nol" {
  allocated_storage      = 10
  name                   = "apigw_nolntc_nol_${terraform.workspace}"
  identifier             = "api-gw-nolntc-nol-${terraform.workspace}"
  final_snapshot_identifier = "api-gw-nolntc-nol-${terraform.workspace}-${uuid()}"
  engine                 = "postgres"
  engine_version         = "10.6"
  storage_encrypted      = true
  instance_class         = "db.m4.xlarge"
  storage_type           = "gp2"
  username               = "${var.rds_user}"
  password               = "${data.aws_ssm_parameter.kongdbpassword.value}"
  publicly_accessible    = false
  db_subnet_group_name   = "api-gw-rds_nolntc-nol-${terraform.workspace}"
  vpc_security_group_ids = ["${aws_security_group.rds-nol.id}"]
  depends_on = ["aws_db_subnet_group.default"]
  depends_on = ["aws_ssm_parameter.kongdbpassword.name"]
  tags   = "${merge(local.tags, map("Name", "NOL Kong DB -${terraform.workspace}"))}"
}

# Setup subnet group so RDS is in private subnets in correct VPC
resource "aws_db_subnet_group" "default" {
  name = "api-gw-rds_nolntc-nol-${terraform.workspace}"

  subnet_ids = [
    "${local.private_subnets[terraform.workspace]}",
  ]

  tags   = "${merge(local.tags, map("Name", "NOL Kong Subnet - ${terraform.workspace}"))}"
}
