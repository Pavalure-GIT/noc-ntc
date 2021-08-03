remote_state_bucket = {

  dev = "dwp-nolntc-dev-terraform-states"
  test  = "dwp-nolntc-dev-terraform-states"
  stage = "dwp-nolntc-prod-terraform-states"
  prod  = "dwp-nolntc-prod-terraform-states"
}

private_hosted_zone_name = {
  dev = "wa-dev-nolntc.dwpcloud.uk"
  test = "wa-test-nolntc.dwpcloud.uk"
  stage = "wa-stage-nolntc.dwpcloud.uk"
  prod  = "wa-prod-nolntc.dwpcloud.uk"
}


workspace = {

  dev = "nonproductiom"
  test  = "nonproductiom"
  stage = "production"
  prod  = "production"
}


domain_names_nol = {

  dev   = "wa-nol-dev.wa-dev-nolntc.dwpcloud.uk"
  test  = "wa-nol-test.wa-test-nolntc.dwpcloud.uk"
  stage = "wa-nol-stage.wa-stage-nolntc.dwpcloud.uk"
  prod  = "wa-nol-prod.service.dwpcloud.uk"
}

additional_names_nol = {

  dev = []
  test  = []
  stage = []
  prod  = ["wa-nol-prod.wa-prod-nolntc.dwpcloud.uk"]
}

domain_names_ntc = {

  dev   = "wa-ntc-dev.wa-dev-nolntc.dwpcloud.uk"
  test  = "wa-ntc-test.wa-test-nolntc.dwpcloud.uk"
  stage = "wa-ntc-stage.wa-stage-nolntc.dwpcloud.uk"
  prod  = "wa-ntc-prod.service.dwpcloud.uk"
}

additional_names_ntc = {

  dev = []
  test  = []
  stage = []
  prod  = ["wa-ntc-prod.wa-prod-nolntc.dwpcloud.uk"]
}



integration_cidr_block= {

  dev = ""
  test  = ""
  stage = ""
  prod  = "10.92.100.0/22"
}

integration_vpc_id = {

  dev = ""
  test  = "vpc-0fbb7167"
  stage = ""
  prod  = "vpc-ab7bc8c3"
}

integration_peer_account_id = {

  dev = ""
  test  = "731252101191"
  stage = ""
  prod  = "072874872668"
}

integration_hosted_zone_id = {

  dev = ""
  test  = ""
  stage = ""
  prod  = "Z2W3MDPB0JY6ZT"
}

env = "${terraform.workspace}"