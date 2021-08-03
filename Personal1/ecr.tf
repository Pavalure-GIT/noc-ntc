
resource "aws_ecr_repository" "ntc-web" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"   
    name = "ntc-web"
}

 resource "aws_ecr_repository_policy" "ntc-web-policy" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"
    repository = "${aws_ecr_repository.ntc-web.name}"
    policy = "${data.template_file.ecr_policy.rendered}"
}

resource "aws_ecr_repository" "ntc-audit-batch" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"
    name = "ntc-audit-batch"
}
 resource "aws_ecr_repository_policy" "ntc-audit-batch-policy" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"
    repository = "${aws_ecr_repository.ntc-audit-batch.name}"
    policy = "${data.template_file.ecr_policy.rendered}"
}


resource "aws_ecr_repository" "ntc-sft" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"
    name = "ntc-sft"
}

 resource "aws_ecr_repository_policy" "ntc-sft-policy" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"
    repository = "${aws_ecr_repository.ntc-sft.name}"
    policy = "${data.template_file.ecr_policy.rendered}"
}


data "template_file" "ecr_policy" {
  count = "${terraform.workspace == "dev" ? 1 : 0}"
  template = "${file(format("%s/assets/ecr_policy.json", path.module))}"
  vars {
    nonproduction_account_id = "${var.account_id["dev"]}"
    production_account_id = "${var.account_id["prod"]}"
  }
}
