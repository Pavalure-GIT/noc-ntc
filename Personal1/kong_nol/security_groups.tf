# Security group for RDS postgres database
resource "aws_security_group" "rds-nol" {
  name_prefix = "api-gw-rds-${terraform.workspace}"
  description = "API GW RDS NOL ${terraform.workspace} security group"
  vpc_id      = "${local.vpc_id[terraform.workspace]}"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }
  tags = "${merge(local.tags, map("Name", "NOL Kong DB Security Group -${terraform.workspace}"))}"
}

####  Once working tighten up th security groups below

resource "aws_security_group" "main_alb_nol" {
  name_prefix = "api-gw-lb-nol-${terraform.workspace}"
  description = "api nol ${terraform.workspace} gw load balancer"
  vpc_id      = "${local.vpc_id[terraform.workspace]}"

  ingress {
    from_port   = 8443
    to_port     = 8444
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
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["51.0.0.0/8"]
  }
  
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["51.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

  tags   = "${merge(local.tags, map("Name", "NOL Kong Loadbalancer Security Group -${terraform.workspace}"))}"
}

resource "aws_security_group" "instance" {
  name_prefix = "api-gw-nol-${terraform.workspace}"
  description = "api gw nol ${terraform.workspace} instance"
  vpc_id      = "${local.vpc_id[terraform.workspace]}"

  # Metrics
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  }

ingress {
    from_port   = 8443
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.mgmt_vpc_cidr}"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags   = "${merge(local.tags, map("Name", "NOL Kong EC2 Instance Security Group -${terraform.workspace}"))}"
}


resource "aws_security_group_rule" "allow_ssh" {
  count     = "${terraform.workspace== "prod" || terraform.workspace == "pft1" ? 0 : 1}"
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}"]
  security_group_id = "${aws_security_group.instance.id}"
}
