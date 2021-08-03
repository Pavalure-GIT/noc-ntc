### create aws task definition for ecs cluster service ###
resource "aws_ecs_task_definition" "ntc-web-task" {
  family                = "ntc-web-task"
  network_mode          = "host"
  execution_role_arn    = "${aws_iam_role.nolntc-default-task.arn}"
  container_definitions = "${data.template_file.ntc-web-task.rendered}"

  tags   = "${merge(local.tags, map("Name", "ntc-web-task-${terraform.workspace}"))}"
}

resource "aws_ecs_task_definition" "ntc-api-hmrc-stub-task" {
  count = "${terraform.workspace == "prod" ? 0 : 1}"
  family                = "ntc1-api-hmrc-stub-task"
  container_definitions = "${data.template_file.ntc-api-hmrc-stub-task.rendered}"

  tags   = "${merge(local.tags, map("Name", "ntc-api-hmrc-stub-task-${terraform.workspace}"))}"
 }

resource "aws_ecs_task_definition" "ntc-audit-batch-task" {
  family                = "ntc1-audit-batch-task"
  execution_role_arn    = "${aws_iam_role.nolntc-default-task.arn}"
  container_definitions = "${data.template_file.ntc-audit-batch-task.rendered}"  
    volume {
    name = "fileshare"
    host_path = "/opt/localmount/audit"
  }
  tags   = "${merge(local.tags, map("Name", "ntc-audit-batch-task-${terraform.workspace}"))}"
}

resource "aws_ecs_task_definition" "ntc-sft-task" {
  family                = "ntc-sft-task"
  execution_role_arn    = "${aws_iam_role.nolntc-default-task.arn}"
  container_definitions = "${data.template_file.ntc-sft-task.rendered}"  
    volume {
    name = "fileshare"
    host_path = "/opt/localmount"
  }

  tags   = "${merge(local.tags, map("Name", "ntc-sft-task-${terraform.workspace}"))}"
}
