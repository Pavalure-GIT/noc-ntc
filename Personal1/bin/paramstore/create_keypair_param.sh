#!/usr/bin/env bash

KEYPAIR_NAME="${1}"

# TODO - check for PROFILE env var (or select from list)
#e.g. PROFILE=nonproduction

aws ssm get-parameter --name "/NOLNTC/${KEYPAIR_NAME}" --query 'Parameter.Value' --output text
if [[ $? -ne 0 ]]; then
     aws ec2 delete-key-pair --key-name ${KEYPAIR_NAME} --output text
     aws ec2 create-key-pair --key-name ${KEYPAIR_NAME} --query 'KeyMaterial' --output text > ${KEYPAIR_NAME}.pem
     aws ssm put-parameter  --name "/NOLNTC/${KEYPAIR_NAME}" --value "$(cat ${KEYPAIR_NAME}.pem)" --type SecureString --overwrite
     #rm -f ${KEYPAIR_NAME}.pem
     echo "Creating Key pair"
else
     echo "Key pair already exists"
fi