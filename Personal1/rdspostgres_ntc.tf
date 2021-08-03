#####   Create Postgres RDS Instance for ntc test  #########

resource "aws_db_subnet_group" "subnet_group" {
  subnet_ids = [
    "${local.private_subnets[terraform.workspace]}"
  ]
}

resource "aws_db_instance" "ntc-db" {
  allocated_storage       = 100                               # gigabytes
  backup_retention_period = 7                                 # in days
  db_subnet_group_name    = "${aws_db_subnet_group.subnet_group.name}"
  engine                  = "postgres"
  engine_version          = "10.6"
  identifier              = "ntcdb${terraform.workspace}"
  final_snapshot_identifier = "ntc-db-${terraform.workspace}-${uuid()}"
  instance_class          = "db.t2.medium"
  multi_az                = true
  name                    = "ntcdb${terraform.workspace}"
  parameter_group_name    = "default.postgres10"              # if you have tuned it
  password               = "${data.aws_ssm_parameter.password.value}"
  port                   = 5432
  publicly_accessible    = false
  storage_encrypted      = true                                  # you should always do this
  storage_type           = "gp2"
  username               = "${var.rds_username}"
  vpc_security_group_ids = ["${aws_security_group.ntc-db-sg.id}"]

  tags   = "${merge(local.tags, map("Name", "ntc-db-${terraform.workspace}"))}"
  
}

#### create security group for RDS Instance ######

resource "aws_security_group" "ntc-db-sg" {
  name = "ntc-db-sg-${terraform.workspace}"
  tags   = "${merge(local.tags, map("Name", "ntc-db-sg-${terraform.workspace}"))}"
  description = "RDS postgres servers (terraform-managed)"
  vpc_id      = "${local.vpc_id[terraform.workspace]}"

  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
