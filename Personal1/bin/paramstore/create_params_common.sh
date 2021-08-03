#!/usr/bin/env bash
ENVIRONMENT="${1}"
# COMMON
# This key is used by Application Support to access the Bastion server
./paramstore/create_keypair_param.sh NOLNTCBastionKeyPair

# This key is to used for all EC2 instances across NOL and NTC from the bastion server
./paramstore/create_keypair_param.sh nol_key1
