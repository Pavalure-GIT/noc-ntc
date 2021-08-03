### create ECS Cluster #####


##### ntc  ######
resource "aws_ecs_cluster" "ntc-ecs-cluster" {
  name = "ntc-ecs-cluster-${terraform.workspace}"

  tags   = "${merge(local.tags, map("Name", "ntc-ecs-cluster-${terraform.workspace}"))}"
}
