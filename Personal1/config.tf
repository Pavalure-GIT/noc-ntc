//terraform {
//  backend "s3" {
//    key            = "MODIFY"
//    region         = "${var.region}"
//    dynamodb_table = "MODIFY"
//    encrypt        = true
//  }
//}
terraform {
  backend "s3" {
    key            = "nol-ntc-r/monitoring"
    region         = "eu-west-2"
    dynamodb_table = "tflock-test"
    encrypt        = true
  }
}
