#!/usr/bin/env bash

PARAM_NAME="${1}"

aws ssm get-parameter  --name "${PARAM_NAME}" --query 'Parameter.Value' --output text
if [[ $? -ne 0 ]]; then
    NEWVALUE=$(uuidgen | tr -d '\n')
    echo "Creating ${PARAM_NAME}"
    aws ssm put-parameter --name "${PARAM_NAME}" --value "${NEWVALUE}" --type SecureString --overwrite
else
    echo "${PARAM_NAME} already exists"
fi