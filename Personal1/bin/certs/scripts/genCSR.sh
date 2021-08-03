#Generate Certifcate Signing Request - Can be used to generate CSR for CIS and SDX

SR_CN="wa-prod-nolntc.dwpcloud.gov.uk"
CSR_OU="NOL-R"
CSR_C="GB"
CSR_ST="Newcastle"
CSR_L="Newcastle"
CSR_O="DWP"

KEY_FILE="onboard-prod-${CSR_OU}.key"
CSR_FILE="onboard-prod-${CSR_OU}.csr"

openssl genrsa -out "${KEY_FILE}" 2048
openssl req -out "${CSR_FILE}" -key "${KEY_FILE}" -new -subj "/C=${CSR_C}/ST=${CSR_ST}/L=${CSR_L}/O=${CSR_O}/OU=${CSR_OU}/CN=${CSR_CN}"

openssl req -text -noout -verify -in ${CSR_FILE}
