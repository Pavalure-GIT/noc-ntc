resource "null_resource" "delete_current_db_instance" {

  provisioner "local-exec" {
    command = "aws rds delete-db-instance --db-instance-identifier noldb${terraform.workspace} --skip-final-snapshot --no-delete-automated-backups"
  }
}