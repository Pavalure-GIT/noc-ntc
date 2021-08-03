resource "aws_alb" "ntc-alb" {
  name     = "ntc-alb-${terraform.workspace}"
  internal = true
  subnets  = ["${local.private_subnets[terraform.workspace]}"]
  security_groups = ["${aws_security_group.ntc_alb_sg.id}"]
  load_balancer_type = "application"
  
  tags   = "${merge(local.tags, map("Name", "ntc-alb-${terraform.workspace}"))}"

}

#network load balancer - NOT Required as no inbound SFT
resource "aws_lb" "ntc-nlb" {
  name     = "ntc-nlb-${terraform.workspace}"
  internal = true
  subnets  = ["${local.private_subnets[terraform.workspace]}"]
  load_balancer_type = "network"
  tags   = "${merge(local.tags, map("Name", "ntc-nlb-${terraform.workspace}"))}"
}

resource "aws_lb_listener" "ntc-lb-audit-batch-listener" {
  load_balancer_arn = "${aws_lb.ntc-nlb.arn}"
  port              = "8446"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.ntc-audit-batch-tg.arn}"
    type             = "forward"
  }
}

# NO Current Inbound SFT for NTC 
# This is used for health checks - Ensure that there is no inbound traffic allowed
# Otherwise SDX will route NOL inbound traffic to this port
# Other than internal CIDRs

resource "aws_lb_listener" "ntc-lb-sft-listener" {
  load_balancer_arn = "${aws_lb.ntc-nlb.arn}"
  port              = "8091"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.ntc-sft-tg.arn}"
    type             = "forward"
  }
}

//Create Security Group For NTC Network Load Balancer Instance
#### create security group for NTC load Balancer Instance ######
resource "aws_security_group" "ntc_alb_sg" {
  name = "ntc_alb_sg"

  description = "Security Group for NTC test ALB (terraform-managed)"
  vpc_id      = "${local.vpc_id[terraform.workspace]}"
  tags   = "${merge(local.tags, map("Name", "ntc_alb_sg-${terraform.workspace}"))}"
  

  # Only all inbound tcp traffic
  # Only all inbound tcp traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["51.0.0.0/8"]
  }

  ingress {
    from_port   = 8098
    to_port     = 8098
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  ingress {
    from_port   = 8444
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  # egress rules
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 8446
    to_port     = 8446
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 8098
    to_port     = 8098
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 8444
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  egress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  # ecs agent
  egress {
    from_port   = 51678
    to_port     = 51679
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  # docker
  egress {
    from_port   = 2376
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  # docker
  egress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
  # docker
  egress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }
}

resource "aws_alb_listener" "ntc-alb-https" {
  load_balancer_arn = "${aws_alb.ntc-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "${var.domain_cert_arn[terraform.workspace]}"

  default_action {
    target_group_arn = "${aws_alb_target_group.ntc-alb-https-tg.arn}"
    type             = "forward"
  }
}


resource "aws_alb_listener" "ntc-alb-hmrc-stub" {
  count = "${terraform.workspace == "prod" ? 0 : 1}"
  load_balancer_arn = "${aws_alb.ntc-alb.arn}"
  port              = "8098"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${var.domain_cert_arn[terraform.workspace]}"

  default_action {
    target_group_arn = "${aws_alb_target_group.ntc-api-hmrc-stub.arn}"
    type             = "forward"
  }
}



resource "aws_autoscaling_attachment" "ntc-alb-https" {
  autoscaling_group_name = "${aws_autoscaling_group.ntc-ecs-cluster-EcsInstanceAsg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.ntc-alb-https-tg.arn}"
}

resource "aws_autoscaling_attachment" "ntc-alb-ntc-sft" {
  autoscaling_group_name = "${aws_autoscaling_group.ntc-ecs-cluster-EcsInstanceAsg.id}"
  alb_target_group_arn   = "${aws_lb_target_group.ntc-sft-tg.arn}"
}

#port 8098 - api hmrc stub
resource "aws_autoscaling_attachment" "ntc-alb-api-hmrc-stub8098" {
 count = "${terraform.workspace == "prod" ? 0 : 1}"
 autoscaling_group_name = "${aws_autoscaling_group.ntc-ecs-cluster-EcsInstanceAsg.id}"
 alb_target_group_arn   = "${aws_alb_target_group.ntc-api-hmrc-stub.arn}"
}

#Audit Batch

resource "aws_autoscaling_attachment" "ntc-alb-ntc-audit-batch" {
  autoscaling_group_name = "${aws_autoscaling_group.ntc-ecs-cluster-EcsInstanceAsg.id}"
  alb_target_group_arn   = "${aws_lb_target_group.ntc-audit-batch-tg.arn}"
}


