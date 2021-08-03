data "terraform_remote_state" "network" {
  backend = "s3"
  workspace = "${var.network_workspace[terraform.workspace]}"

  config {
    bucket = "${var.remote_state_bucket[terraform.workspace]}"
    key    = "nol-ntc-r/network"
    region = "eu-west-2"
  }
}
