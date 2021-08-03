### autoscaling group for ECS ###

##### ntc ########

resource "aws_autoscaling_group" "ntc-ecs-cluster-EcsInstanceAsg" {
  name                      = "EC2ContainerService-ntc${terraform.workspace}-ecs-cluster-EcsInstanceAsg"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true

  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
  vpc_zone_identifier  = ["${local.private_subnets[terraform.workspace]}"]


  tags = ["${
      concat(
      local.asg_tags,
      list(
        map(
          "key", "Name",
          "value", "ECS Instance - EC2ContainerService-ntc-ecs-cluster ${terraform.workspace}",
          "propagate_at_launch", true
          )
        )
      )
    }"]


}
