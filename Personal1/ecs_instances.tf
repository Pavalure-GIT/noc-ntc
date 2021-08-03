### create ecs instances via aws launch configuration ###

resource "aws_security_group" "ntc-ecs-instances" {
  name = "ntc-${terraform.workspace}-ecs-instances_sg"

  description = "ECS EC2 instances security group (terraform-managed)"
  vpc_id      = "${local.vpc_id[terraform.workspace]}"

  # Only postgres in
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    description = "Main web application access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    description = "Manual trigger of NTC Audit Batch Application"
    from_port   = 8446
    to_port     = 8446
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    description = "NTC Stub api access"
    from_port   = 8098
    to_port     = 8098
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    description = "SFT Inbound access"
    from_port   = 8090
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  ingress {
    description = "Production HMRC API Access"
    from_port   = 8843
    to_port     = 8843
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]

  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]

  }

  # ecs agent
  ingress {
    from_port   = 51678
    to_port     = 51679
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # docker
  ingress {
    from_port   = 2376
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # docker
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # docker
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

    # docker
  ingress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }
  # prometheus
  ingress {
    from_port = 9100
    to_port   = 9100
    protocol  = "tcp"
    description = "Prometheus node exporter"
    cidr_blocks = ["${local.mgmt_vpc_cidr}"]
  }

  # egress rules
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]

  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 8446
    to_port     = 8446
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 8098
    to_port     = 8098
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 8444
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # ecs agent
  egress {
    from_port   = 51678
    to_port     = 51679
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }
  # docker
  egress {
    from_port   = 2376
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }
  # docker
  egress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # docker
  egress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # squid proxy
  egress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

  # SFT Outbound
  egress {
    from_port   = 8090
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = ["${local.vpc_cidr[terraform.workspace]}","${local.mgmt_vpc_cidr}"]
  }

    # SFT Outbound
  egress {
    from_port   = 8090
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # HMRC Outbound

  egress {
    from_port   = 8843
    to_port     = 8843
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  tags   = "${merge(local.tags, map("Name", "ntc-${terraform.workspace}-ecs-instances_sg"))}"
}

resource "aws_launch_configuration" "ecs_instance" {
  security_groups = ["${aws_security_group.ntc-ecs-instances.id}"]
  key_name        = "${var.key_name}"
  image_id  = "${data.aws_ami.hardened_ami_encrypted.id}"
  user_data = "${data.template_file.ntc-docker-ecs-user-data.rendered}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecsInstanceProfile.name}"
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "hardened_ami_encrypted" {
  most_recent = "true"
  owners      = ["${var.ami_owner[terraform.workspace]}"]
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name = "name"
    values = ["${var.ami_filter[terraform.workspace]}"]

  }
}
