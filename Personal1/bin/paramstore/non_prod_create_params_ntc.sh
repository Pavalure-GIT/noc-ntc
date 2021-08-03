#!/usr/bin/env bash
ENVIRONMENT="${1}"

aws configure set region eu-west-2

###### NTC ########
./create_uuid_param.sh /NOLNTC/NTC/${ENVIRONMENT}/rds_password
./create_uuid_param.sh /NOLNTC/NTC/${ENVIRONMENT}/KONG_DB_PASSWORD
./create_uuid_param.sh /NOLNTC/NTC/${ENVIRONMENT}/KONG_PASSWORD