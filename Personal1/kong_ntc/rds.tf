# Create RDS instance
resource "aws_db_instance" "default_nolntc_ntc" {
  allocated_storage      = 10
  backup_retention_period = 7 
  name                   = "apigw_nolntc_ntc_${terraform.workspace}"
  identifier             = "api-gw-nolntc-ntc-${terraform.workspace}"
  final_snapshot_identifier = "api-gw-nolntc-ntc-${terraform.workspace}-${uuid()}"
  engine                 = "postgres"
  engine_version         = "10.6"
  storage_encrypted      = true
  instance_class         = "db.m4.xlarge"
  storage_type           = "gp2"
  username               = "${var.rds_user}"
  password               = "${data.aws_ssm_parameter.kongdbpassword.value}"
  publicly_accessible    = false
  db_subnet_group_name   = "api-gw-rds_ntc_${terraform.workspace}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  depends_on = ["aws_db_subnet_group.default"]
  depends_on = ["aws_ssm_parameter.kongpassword.name"]
  tags   = "${merge(local.tags, map("Name", "NTC Kong DB -${terraform.workspace}"))}"
}

# Setup subnet group so RDS is in private subnets in correct VPC
resource "aws_db_subnet_group" "default" {
  name = "api-gw-rds_ntc_${terraform.workspace}"

  subnet_ids = [
    "${local.private_subnets[terraform.workspace]}",
  ]
}
