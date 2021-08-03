##### create ecs cluster service #####
#### ntc ####
resource "aws_ecs_service" "ntc-web-service" {
  name            = "ntc-web-service-${terraform.workspace}"
  cluster         = "${aws_ecs_cluster.ntc-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.ntc-web-task.arn}"
  desired_count   = 2
  iam_role = "${aws_iam_role.ecsServiceRoleNOLNTC.arn}"
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ntc-alb-https-tg.arn}"
    container_name   = "ntc-web-container"
    container_port   = 8443
  }
	depends_on = [
	"aws_alb.ntc-alb"
	]
  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "0"
  # There is the long arn issue with ECS tagging removing for now
  #tags   = "${merge(local.tags, map("Name", "ntc-web-service-${terraform.workspace}"))}"
  
}

resource "aws_ecs_service" "ntc-audit-batch-service" {
  name            = "ntc-audit-batch-service-${terraform.workspace}"
  cluster         = "${aws_ecs_cluster.ntc-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.ntc-audit-batch-task.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecsServiceRoleNOLNTC.arn}"
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.ntc-audit-batch-tg.arn}"
    container_name   = "ntc-audit-batch-container"
    container_port   = 8443
  }
	depends_on = [
	  "aws_lb.ntc-nlb"
	]

  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "0"

  #tags   = "${merge(local.tags, map("Name", "ntc-audit-batch-service-${terraform.workspace}"))}"
}

resource "aws_ecs_service" "ntc-sft-service" {
  name            = "ntc-sft-service-${terraform.workspace}"
  cluster         = "${aws_ecs_cluster.ntc-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.ntc-sft-task.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecsServiceRoleNOLNTC.arn}"
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.ntc-sft-tg.arn}"
    container_name   = "ntc-sft-container"
    container_port   = 8091
  }
	depends_on = [
	  "aws_lb.ntc-nlb"
	]

  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "0"

  #tags   = "${merge(local.tags, map("Name", "ntc-audit-batch-service-${terraform.workspace}"))}"
}

# Stub Services only should be in the dev and test and staging accounts not in production
resource "aws_ecs_service" "ntc-hmrc-stub-service" {
  count = "${terraform.workspace == "prod" ? 0 : 1}"
  name            = "ntc-hmrc-stub-service-${terraform.workspace}"
  cluster         = "${aws_ecs_cluster.ntc-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.ntc-api-hmrc-stub-task.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecsServiceRoleNOLNTC.arn}"
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ntc-api-hmrc-stub.arn}"
    container_name   = "ntc-api-hmrc-stub-container"
    container_port   = 8080
  }
	depends_on = [
	  "aws_alb.ntc-alb"
	]
  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "0"

}

