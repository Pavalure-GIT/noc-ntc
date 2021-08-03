data "terraform_remote_state" "network" {
  backend = "s3"
  workspace = "${var.network_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/network"
    region = "eu-west-2"
  }
}


data "terraform_remote_state" "ntc" {
  backend = "s3"
  workspace = "${terraform.workspace}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/ntc"
    region = "eu-west-2"
  }
}

data "aws_ssm_parameter" "password" {
  name = "/NOLNTC/NTC/${terraform.workspace}/rds_password"
}
