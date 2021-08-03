#!/bin/bash

# Environment Variable must be set as Pem as continuious string
CSR=`awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' dev_NOL-R.csr`
CSR_FILE=csr.csr
DAYS=730
echo "CSR is:"
echo "$CSR" | tee $CSR_FILE
echo "Reformatting CSR with whitespace. It is now:"
CSR=$(sed -e 's/%n/\'$'\n/g' -e 's/%s/ /g' -e 's/%e/=/g' $CSR_FILE)
echo "$CSR" | tee $CSR_FILE

#Get the Root CA, Key from the parameter store

aws ssm get-parameter --name "/NOLNTC/NOLNTC_ROOT_CA_CRT"  --with-decryption --query 'Parameter.Value' --output text > nolntc-ca.crt
aws ssm get-parameter --name "/NOLNTC/NOLNTC_ROOT_CA_KEY"  --with-decryption --query 'Parameter.Value' --output text > nolntc-ca.key
aws ssm get-parameter --name "/NOLNTC/NOLNTC_ROOT_CA_SRL"  --with-decryption --query 'Parameter.Value' --output text > nolntc-ca.srl
aws ssm get-parameter --name "/NOLNTC/SDX_V3"  --with-decryption --query 'Parameter.Value' --output text > v3.conf

openssl x509 -req -sha256 -in $CSR_FILE -CA nolntc-ca.crt -CAkey nolntc-ca.key -extfile v3.conf -CAcreateserial -CAserial nolntc-ca.srl -out NOLNTC.csr.crt -days  ${DAYS}
rm nolntc-ca.crt
rm nolntc-ca.key
rm nolntc-ca.srl
rm v3.conf
rm $CSR_FILE
rm NOLNTC.csr.crt 
echo "CRT created:"
cat NOLNTC.csr.crt
echo "Complete!"


