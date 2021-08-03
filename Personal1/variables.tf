

locals {
  mgmt_vpc_cidr = "${data.terraform_remote_state.network.mgmt_vpc_cidr}"
  vpc_id = {
    dev   = "${data.terraform_remote_state.network.preprod_vpc_id}"
    test  = "${data.terraform_remote_state.network.prod_vpc_id}"
    stage = "${data.terraform_remote_state.network.preprod_vpc_id}"
    prod  = "${data.terraform_remote_state.network.prod_vpc_id}"
  }

  vpc_cidr = {
    dev   = "${data.terraform_remote_state.network.preprod_vpc_cidr}"
    test  = "${data.terraform_remote_state.network.prod_vpc_cidr}"
    stage = "${data.terraform_remote_state.network.preprod_vpc_cidr}"
    prod  = "${data.terraform_remote_state.network.prod_vpc_cidr}"
  }

  private_subnets = {
    dev   = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 0, 2)}"
    test  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 0, 2)}"
    stage = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 0, 2)}"
    prod  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 0, 2)}"
  }

  public_subnets = {
    dev   = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 2, 4)}"
    test  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 2, 4)}"
    stage = "${slice(data.terraform_remote_state.network.preprod_vpc_subnet_ids, 2, 4)}"
    prod  = "${slice(data.terraform_remote_state.network.prod_vpc_subnet_ids, 2, 4)}"
  }
}

variable "remote_state_bucket" {
  type        = "map"
  description = "Terrform remote state bucket"
}

variable "network_workspace" {
  type = "map"

  default = {
    dev   = "nonproduction"
    test  = "nonproduction"
    stage = "production"
    prod  = "production"
  }
}


# Peering owner id for connecting into non prod

variable "rds_username" {
  default     = "dbadmin"
  description = "RDS db admin username"
}

variable "environments"{
  type = "map"
  default = {
    dev = "NOL-R Development"
    test = "NOL-R Test"
    stage = "NOL-R Staging"
    prod = "NOL-R Production"

  }
}

locals {
  tags = {
    Application = "NTC View Only / Online"
    Costcode = "10389675"
    Owner = "Working Age"
    Environment = "${var.environments[terraform.workspace]}"
  }

  asg_tags = [
    {
      key                 = "Environment"
      value               = "${var.environments[terraform.workspace]}"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "NTC View Only / Online"
      propagate_at_launch = true
    },
    {
      key                 = "Costcode"
      value               = "10389675"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Working Age"
      propagate_at_launch = true
    }
  ]
}
