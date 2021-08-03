#!/usr/bin/env bash
ENVIRONMENT="${1}"
# ####### NTC
./paramstore/create_uuid_param.sh /NOLNTC/NTC/${ENVIRONMENT}/rds_password
./paramstore/create_uuid_param.sh /NOLNTC/NTC/${ENVIRONMENT}/KONG_DB_PASSWORD
./paramstore/create_uuid_param.sh /NOLNTC/NTC/${ENVIRONMENT}/KONG_PASSWORD

