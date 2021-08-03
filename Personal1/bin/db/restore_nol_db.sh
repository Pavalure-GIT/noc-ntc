#!/usr/bin/env bash
ENVIRONMENT="${1}"

aws configure set region eu-west-2

###### NOL ########
cd nol_restore
terraform init -backend-config=backend_config/${ENVIRONMENT}.conf
terraform workspace select dev || terraform workspace new dev
terraform import aws_db_instance.nol-db noldbd${ENVIRONMENT}
terraform apply -target=null_resource.delete_current_db_instance -auto-approve
terraform apply -target=aws_db_instance.nol-db -auto-approve

