#!/bin/bash

# Script that can be used as part of the HCS Deployer to upload file contents to the parameter store
# Can be used to upload Certificates and Keys
# Environment Variables, set in the json for the HCS Deployer (See cloudformation folder for example)

# File contents must be set as a continious string
FILECONTENT=`awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' dev_NOL-R.csr`
PARAMNAME="/NOLNTC/FILETEST"

FILE=file
DAYS=730
echo "FILECONTENT is:"
echo "$FILECONTENT" | tee $FILE
echo "Reformatting FILECONTENT with whitespace. It is now:"
FILECONTENT=$(sed -e 's/%n/\'$'\n/g' -e 's/%s/ /g' -e 's/%e/=/g' $CSR_FILE)
echo "$FILECONTENT" | tee $FILE


aws ssm put-parameter --profile=nonproduction --overwrite --name "$PARAMNAME" --type SecureString --value "$(cat $FILE)"

echo "Parameter $PARAMNAME created:"

echo "Complete!"


