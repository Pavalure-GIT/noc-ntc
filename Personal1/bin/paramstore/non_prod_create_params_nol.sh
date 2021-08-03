#!/usr/bin/env bash
ENVIRONMENT="${1}"

aws configure set region eu-west-2

###### NOL ########
./create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/rds_password
./create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/KONG_DB_PASSWORD
./create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/KONG_PASSWORD
 # PGP Encryption key used by NOL batch to encrypt sensitive data before persisting to the database
 # -and used by nol-web to decrypt sensitive data before displaying
 

# Specific Pgcrpto Key for Dev/Test environments
aws ssm get-parameter  --name "/NOLNTC/NOL/${ENVIRONMENT}/PGCRYPTO_KEY"  --with-decryption --query 'Parameter.Value' --output text
if [[ $? -ne 0 ]]; then
    echo "Creating Test /NOLNTC/NOL/${ENVIRONMENT}/PGCRYPTO_KEY"
    aws ssm put-parameter --name "/NOLNTC/NOL/${ENVIRONMENT}/PGCRYPTO_KEY" --value "298F0CB3" --type SecureString --overwrite
else
    echo "PGCRYPTO key already exists"
fi
# COMMON
# This key is used by Application Support to access the Bastion server
./create_keypair_param.sh NOLNTCBastionKeyPair

# This key is to used for all EC2 instances across NOL and NTC from the bastion server
./create_keypair_param.sh nol_key1
