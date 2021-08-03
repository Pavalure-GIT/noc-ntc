###################### INTERNET GATEWAY ####################
resource "aws_internet_gateway" "gw" {
  vpc_id = "${module.vpc_mgmt.vpc_id}"

  tags {
    Name = "InternetGateway"
  }
}

###################### ROUTES ############################
resource "aws_route" "nat_access" {
  route_table_id         = "${module.vpc_mgmt_subnets.route_table_ids[0]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${module.vpc_mgmt_subnets.route_table_ids[2]}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

###################### ELASTIC IP ########################
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gw"]
}

###################### NAT GATEWAY    ####################
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${module.vpc_mgmt_subnets.subnet_ids[2]}"
  depends_on    = ["aws_internet_gateway.gw"]
}

###################### SQUID SECURITY GROUP ###############################

resource "aws_security_group" "squid-sg" {
  name        = "squid security group"
  description = "Security Group for Squid Proxy"
  vpc_id      = "${module.vpc_mgmt.vpc_id}"

  ingress {
    from_port   = "3128"
    to_port     = "3128"
    protocol    = "tcp"
    cidr_blocks = [
      "${var.vpc_mgmt_cidr[terraform.workspace]}",
      "${var.vpc_prod_cidr[terraform.workspace]}",
      "${var.vpc_preprod_cidr[terraform.workspace]}"]
    description = "Proxy access"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_mgmt_cidr[terraform.workspace]}"]
    description = "ssh access"
  }

  # Replace the allow all egress rule that terraform automatically removes by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All egress"
  }
}

output "squid-sg" {
  value = "${aws_security_group.squid-sg.id}"
}

##################### SQUID PROXY ############################

resource "aws_instance" "squid_proxy" {
  ami                         = "${var.squid_ami_id[terraform.workspace]}"
  instance_type               = "${var.squid_instance_type}"
  subnet_id                   = "${module.vpc_mgmt_subnets.subnet_ids[0]}"
  associate_public_ip_address = false
  private_ip                  = "${var.squid_ip[terraform.workspace]}"
  key_name                    = "${var.squid_keypair}"

  vpc_security_group_ids = [
    "${aws_security_group.squid-sg.id}",
  ]

  #   tag_environments = {
  #   nonproduction    = "NOLNTC Non-Production"
  #   production = "Production"
  # }

  # tag_application = "nol-ntc-r"
  # tag_costcode = "10389675"
  # tag_owner = "CMG"

  user_data = "${data.template_file.linuxuserdata.rendered}"

  tags {
    Name = "NOLNTC Squid Proxy Server"
  }
  tags {
    Application = "${var.tag_application}"
  }
  tags {
    Costcode = "${var.tag_costcode}"
  }
  tags {
    Owner = "${var.tag_owner}"
  }
  lifecycle { ignore_changes = ["user_data"] }
}

data "template_file" "linuxuserdata" {
  template = "${file("${path.module}/assets/linux-userdata.tpl")}"

  vars {
    allowed_sites = "${var.squid_allowed_sites}"
  }
}
