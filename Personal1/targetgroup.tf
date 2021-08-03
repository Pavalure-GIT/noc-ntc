## create target group for ecs load balancer ##

## create target group for Audit Batch ##
resource "aws_lb_target_group" "ntc-audit-batch-tg" {
  name     = "ntc-audit-batch-tg-${terraform.workspace}"
  port     = 8446
  protocol = "TCP"
  vpc_id   = "${local.vpc_id[terraform.workspace]}"

  depends_on = [
    "aws_lb.ntc-nlb",
  ]
}

## create target group for the SFT Application ##
resource "aws_lb_target_group" "ntc-sft-tg" {
  name     = "ntc-sft-tg-${terraform.workspace}"
  port     = 8091
  protocol = "TCP"
  vpc_id   = "${local.vpc_id[terraform.workspace]}"
  depends_on = [
    "aws_lb.ntc-nlb",
  ]
}

# ## create target group for the NTC API Stub ##
resource "aws_alb_target_group" "ntc-api-hmrc-stub" {
 count = "${terraform.workspace == "prod" ? 0 : 1}"
 name = "ntc-api-hmrc-stub-${terraform.workspace}"
 port     = 8098
 protocol = "HTTPS"
 vpc_id   = "${local.vpc_id[terraform.workspace]}"
 stickiness {
    type = "lb_cookie"
	  enabled = true
			}
	health_check {
    matcher = "200,404,400"
    path = "/ws"
 }
}


#Web Application
resource "aws_alb_target_group" "ntc-alb-https-tg" {
  name     = "ntc-alb-https-tg-${terraform.workspace}"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = "${local.vpc_id[terraform.workspace]}"
  stickiness {
    type = "lb_cookie"
	enabled = true
			}
}

