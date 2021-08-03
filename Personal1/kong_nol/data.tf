data "terraform_remote_state" "network" {
  backend   = "s3"
  workspace = "${var.network_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/network"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "nol" {
  backend = "s3"
  workspace = "${var.nol_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/nol"
    region = "eu-west-2"
  }
}
data "terraform_remote_state" "monitoring" {
  backend = "s3"
  workspace = "${var.monitoring_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/monitoring"
    region = "eu-west-2"
  }
}
data "aws_ssm_parameter" "kongpassword" {
  name       = "/NOLNTC/NOL/${terraform.workspace}/KONG_PASSWORD"
}

data "aws_ssm_parameter" "kongdbpassword" {
  name       = "/NOLNTC/NOL/${terraform.workspace}/KONG_DB_PASSWORD"
}

