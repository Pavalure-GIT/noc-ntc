data "terraform_remote_state" "network" {
  backend   = "s3"
  workspace = "${var.network_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/network"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ntc" {
  backend = "s3"
  workspace = "${var.ntc_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/ntc"
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
# data "terraform_remote_state" "core" {
#   backend = "s3"
#   workspace = "${var.core_workspace[terraform.workspace]}"

#   config {
#     bucket = "${var.remote_state_bucket[terraform.workspace]}"
#     key    = "nol-ntc-r/core"
#     region = "eu-west-2"
#   }
# }

data "aws_ssm_parameter" "kongpassword" {
  name       = "/NOLNTC/NTC/${terraform.workspace}/KONG_PASSWORD"
}

data "aws_ssm_parameter" "kongdbpassword" {
  name       = "/NOLNTC/NTC/${terraform.workspace}/KONG_DB_PASSWORD"
}
