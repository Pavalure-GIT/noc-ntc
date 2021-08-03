#!/usr/bin/env bash
ENVIRONMENT="${1}"

aws configure set region eu-west-2

###### NTC ########
cd ntc_restore
terraform init -backend-config=backend_config/${ENVIRONMENT}.conf
terraform workspace select dev || terraform workspace new dev
terraform import aws_db_instance.ntc-db ntcdbd${ENVIRONMENT}
terraform apply -target=null_resource.delete_current_db_instance -auto-approve
terraform apply -target=aws_db_instance.ntc-db -auto-approve
