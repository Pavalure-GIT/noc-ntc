resource "aws_ssm_parameter" "ntcapiendpoint" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/APIENDPOINT"
  description = "API endpoint for NTC"
  type        = "SecureString"
  overwrite   = true
  value       = "${var.ntcapiendpoint[terraform.workspace]}"

  tags   = "${merge(local.tags, map("Name", "ntcapiendpoint-${terraform.workspace}"))}"
}

resource "aws_ssm_parameter" "dburl" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/DBURL"
  description = "NTC DB URL"
  overwrite   = true
  type        = "SecureString"
  value       = "jdbc:postgresql://${aws_db_instance.ntc-db.endpoint}/${aws_db_instance.ntc-db.name}"

  tags   = "${merge(local.tags, map("Name", "dburl-${terraform.workspace}"))}"
}

resource "aws_ssm_parameter" "squidproxy" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/SQUIDPROXYIP"
  description = "SQUID Proxy IP"
  type        = "SecureString"
  overwrite   = true
  value       = "${data.terraform_remote_state.network.squid_private_ip}"

  tags   = "${merge(local.tags, map("Name", "squidproxy-${terraform.workspace}"))}"
}


resource "aws_ssm_parameter" "dbuser" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/DBUSER"
  description = "NTC admin db uuser"
  type        = "SecureString"
  overwrite   = true
  value       = "dbadmin"

  tags   = "${merge(local.tags, map("Name", "dbuser-${terraform.workspace}"))}"
}

resource "aws_ssm_parameter" "ntc_audit_schedule" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/NTC_AUDIT_SCHEDULE"
  description = "Schedule for ntc audit"
  type        = "SecureString"
  overwrite   = true
  value       = "${var.ntc_audit_schedule[terraform.workspace]}"

  tags   = "${merge(local.tags, map("Name", "ntc_audit_schedule-${terraform.workspace}"))}"
}

resource "aws_ssm_parameter" "ntc_audit_file_purge_schedule" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/NTC_AUDIT_FILE_PURGE_SCHEDULE"
  description = "Schedule for NTC audit file purge"
  type        = "SecureString"
  overwrite   = true
  value       = "${var.ntc_audit_file_purge_schedule[terraform.workspace]}"

  tags   = "${merge(local.tags, map("Name", "ntc_audit_file_purge_schedule-${terraform.workspace}"))}"
}
resource "aws_ssm_parameter" "ntc_audit_file_retention" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/NTC_AUDIT_FILE_RETENTION"
  description = "audit File rention for data"
  type        = "SecureString"
  overwrite   = true
  value       = "${var.ntc_audit_file_retention[terraform.workspace]}"

  tags   = "${merge(local.tags, map("Name", "ntc_audit_file_retention-${terraform.workspace}"))}"
}

resource "aws_ssm_parameter" "ntc_spring_profiles_active" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/SPRING_PROFILES_ACTIVE"
  description = "Active spring profile for ntc for spring batch"
  type        = "SecureString"
  overwrite   = true
  value       = "${var.ntc_spring_profiles_active[terraform.workspace]}"

  tags   = "${merge(local.tags, map("Name", "ntc_spring_profiles_active-${terraform.workspace}"))}"
}


resource "aws_ssm_parameter" "auditdburl" {
  name        = "/NOLNTC/NTC/${terraform.workspace}/AUDIT_DBURL"
  description = "NOL AUDIT DB URL"
  overwrite   = true
  type        = "SecureString"
  value       = "jdbc:postgresql://${aws_db_instance.ntc-db.endpoint}/${aws_db_instance.ntc-db.name}?currentSchema=audit"

  tags   = "${merge(local.tags, map("Name", "auditdburl-${terraform.workspace}"))}"
}

