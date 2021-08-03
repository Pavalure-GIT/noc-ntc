### AWS Cloudwatch logs   ###


resource "aws_cloudwatch_log_group" "NTC_WEB_APP" {
  name = "NTC_WEB_APP_${terraform.workspace}"
  retention_in_days = "${var.cloudwatch_retention}"
  tags   = "${merge(local.tags, map("Name", "NTC_WEB_APP-${terraform.workspace}"))}"
}


resource "aws_cloudwatch_log_group" "NTC_AUDIT_BATCH" {
  name = "NTC_AUDIT_BATCH_${terraform.workspace}"
  retention_in_days = "${var.cloudwatch_retention}"
  tags   = "${merge(local.tags, map("Name", "NTC_AUDIT_BATCH-${terraform.workspace}"))}"
}

resource "aws_cloudwatch_log_group" "NTC_SFT" {
  name = "NTC_SFT_${terraform.workspace}"
  retention_in_days = "${var.cloudwatch_retention}"
  tags   = "${merge(local.tags, map("Name", "NTC_SFT-${terraform.workspace}"))}"
}

