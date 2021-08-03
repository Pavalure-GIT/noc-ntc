#####   RESTORE DB INSTANCE USING LATEST SNAPSHOT VERSION #########

data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "ntcdb${terraform.workspace}"
}

resource "null_resource" "delete_current_db_instance" {

  provisioner "local-exec" {
    command = "aws rds delete-db-instance --db-instance-identifier noldb${terraform.workspace} --skip-final-snapshot --no-delete-automated-backups"
  }
}


resource "aws_db_instance" "ntc-db" {
  identifier                = "ntcdb${terraform.workspace}"
  snapshot_identifier       = "${data.aws_db_snapshot.db_snapshot.id}"
  allocated_storage         = 100                                        # gigabytes
  backup_retention_period   = 7                                          # in days
  db_subnet_group_name      = "${data.terraform_remote_state.ntc.ntc_db_subnet_name}"
  engine                    = "postgres"
  engine_version            = "10.6"
  final_snapshot_identifier = "ntc-db-${terraform.workspace}-${uuid()}"
  instance_class            = "db.t2.medium"
  multi_az                  = true
  name                      = "ntcdb${terraform.workspace}"
  parameter_group_name      = "default.postgres10"                     

  password = "${data.aws_ssm_parameter.password.value}"

  port                   = 5432
  publicly_accessible    = false
  storage_encrypted      = true                                  # you should always do this
  storage_type           = "gp2"
  username               = "${var.rds_username}"
  vpc_security_group_ids = ["${data.terraform_remote_state.ntc.ntc_db_sg_id}"]

  tags   = "${merge(local.tags, map("Name", "ntc-db-${terraform.workspace}"))}"
}

