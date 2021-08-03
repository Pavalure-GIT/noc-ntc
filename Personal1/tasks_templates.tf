data "aws_caller_identity" "aws_account" {}

data "template_file" "ntc-web-task" {
  template = "${file(format("%s/assets/NTC-web-task.json", path.module))}"

  vars {
    account_id              = "${var.ecr_account}"
    ntc_web_version         = "${var.ntc_web_version[terraform.workspace]}"
    SQUID_PROXY             = "${data.terraform_remote_state.network.squid_private_ip}"
    env                     = "${terraform.workspace}"
    TASK_ROLE_ARN           = "${aws_iam_role.nolntc-default-task.arn}"

  }
}

data "template_file" "ntc-api-hmrc-stub-task" {
  template = "${file(format("%s/assets/ntc-api-hmrc-stub-task.json", path.module))}"

  vars {
    account_id = "${var.ecr_account}"
  }
}

data "template_file" "ntc-audit-batch-task" {
  template = "${file(format("%s/assets/NTC-audit-batch-task.json", path.module))}"

  vars {
    account_id = "${var.ecr_account}"
    ntc_audit_batch_version = "${var.ntc_audit_batch_version[terraform.workspace]}"
    env = "${terraform.workspace}"

  }
}

data "template_file" "ntc-sft-task" {
  template = "${file(format("%s/assets/ntc-sft-task.json", path.module))}"

  vars {
    account_id = "${var.ecr_account}"
    env        = "${terraform.workspace}"
  }
}

data "template_file" "ntc-docker-ecs-user-data" {
  template = <<EOF
#!/bin/bash
${file(format("%s/assets/prom_user_data.sh", path.module))}
${file(format("%s/assets/NTC_userdata_docker_ecs.tpl", path.module))}
EOF
  vars {
    tf_workspace_name = "${terraform.workspace}"
    proxy_host        = "${data.terraform_remote_state.network.squid_private_ip}"
    efs_dns           = "${aws_efs_file_system.ntc-efs.dns_name}"

    # Vars for prometheus exporter (prim_user_data.sh)
    configuration = "${var.configuration}"
    repository_bucket = "${var.repository_bucket}"
    dwp-ansible-prometheus-node-exporter-version = "${var.dwp-ansible-prometheus-node-exporter-version}"
  }
}
