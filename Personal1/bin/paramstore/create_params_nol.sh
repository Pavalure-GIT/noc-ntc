#!/usr/bin/env bash
ENVIRONMENT="${1}"
###### NOL ########
./paramstore/create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/rds_password
./paramstore/create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/KONG_DB_PASSWORD
./paramstore/create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/KONG_PASSWORD
 # PGP Encryption key used by NOL batch to encrypt sensitive data before persisting to the database
 # -and used by nol-web to decrypt sensitive data before displaying
./paramstore/create_uuid_param.sh /NOLNTC/NOL/${ENVIRONMENT}/PGCRYPTO_KEY

# COMMON
# This key is used by Application Support to access the Bastion server
./paramstore/create_keypair_param.sh NOLNTCBastionKeyPair

# This key is to used for all EC2 instances across NOL and NTC from the bastion server
./paramstore/create_keypair_param.sh nol_key1
