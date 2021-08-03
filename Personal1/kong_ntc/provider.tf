provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    key            = "nol-ntc-r/kong_ntc"
    region         = "eu-west-2"
    dynamodb_table = "terraform_locks"
    kms_key_id     = "alias/dwp-kms-generated"
    encrypt        = true
  }
}
