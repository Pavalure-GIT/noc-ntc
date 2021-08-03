provider "aws" {
  region = "eu-west-2"
  version = "~> 1.53"
}
provider "template" {
  version = "~> 1.0.0"
}

terraform {
  backend "s3" {
    key            = "nol-ntc-r/ntc_restore"
    region         = "eu-west-2"
    dynamodb_table = "terraform_locks"
    kms_key_id     = "alias/dwp-kms-generated"
    encrypt        = true
  }
}
