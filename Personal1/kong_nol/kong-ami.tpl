. /etc/environment
export PROXY_PORT=3128
sudo setenforce 0

sudo firewall-cmd --permanent --add-port=3128/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --permanent --add-port=22/tcp

sudo firewall-cmd --reload
sudo setenforce 1
sudo chmod 777 /etc/yum.conf
echo proxy=http://${SQUID_PROXY}:$PROXY_PORT >> /etc/yum.conf
sudo yum install nano -y
runuser -l kong -c "kong stop"
sed -i -e 's/#admin_listen_ssl=0.0.0.0:8444/admin_listen_ssl=0.0.0.0:8444/g' /etc/kong/kong.conf
sed -i -e 's/#proxy_listen_ssl=0.0.0.0:8443/proxy_listen_ssl=0.0.0.0:8443/g' /etc/kong/kong.conf

sed -i -e 's/pg_user = hardenedKong/pg_user = ${pg_user}/g' /etc/kong/kong.conf
sed -i -e 's/pg_user = apigw_nolntc/pg_user = ${pg_user}/g' /etc/kong/kong.conf

sed -i -e 's/log_level = warn/log_level = debug/g' /etc/kong/kong.conf

sed -i -e 's/pg_password = hardenedKong/pg_password = ${pg_password}/g' /etc/kong/kong.conf
sed -i -e 's/pg_password = k1NgK0nG/pg_password = ${pg_password}/g' /etc/kong/kong.conf

sed -i -e 's/pg_database = hardenedKong/pg_database = ${pg_database}/g' /etc/kong/kong.conf
sed -i -e 's/pg_database = apigw_nolntc/pg_database = ${pg_database}/g' /etc/kong/kong.conf

sed -i -e 's/pg_host = hardenedkong.ceyjtrvmwlcu.eu-west-2.rds.amazonaws.com/pg_host = ${pg_endpoint}/g' /etc/kong/kong.conf
sed -i -e 's/pg_host = api-gw-nolntc.ct2ygoys4fsm.eu-west-2.rds.amazonaws.com/pg_host = ${pg_endpoint}/g' /etc/kong/kong.conf

# Temporary fix to set SAML version to 1.1 for NameIdPolicy
sudo sed -i -e 's/urn:oasis:names:tc:SAML:2.0:nameid-format:unspecified/urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified/g' /usr/local/share/lua/5.1/kong/plugins/dwp-auth-saml/customAuthnReq.lua
# end fix

# Switch to correct issuer so dwp-role-restrict works correctly
sed -i -e 's/plugin_saml=dwp-saml/plugin_saml=dwp-adfs/g' /home/kong/kong/gateway.properties

# Prevent dwp-cis-samltojwt throwing error if no application_role found
sudo sed -i -e 's/helper.returnInvalidResponseToClient.*/attributeValueElement = { [attributeName] = "NONE" }/g' /usr/local/share/lua/5.1/kong/plugins/dwp-cis-samltojwt/handler.lua

runuser -l kong -c "kong migrations up -conf /etc/kong/kong.conf &"
runuser -l kong -c "kong start"

#Remove API if already exists
curl -X DELETE ${gateway}/${name}

#Create API
api=$(curl -X POST ${gateway} \
--data 'name=${name}' \
--data 'methods=GET,POST,OPTIONS,PUT' \
--data 'upstream_url=${upstream_url}' \
--data 'strip_uri=true' | jq -r '.id')

#For dev and test environments, go straight to end point
if [[ "${env}" == "production" ]]; then

    echo $api
    #dwp-sso-verify plugin (priority=1000)
    curl -X POST ${gateway}/$api/plugins/ \
    --data 'name=dwp-sso-verify' \
    --data 'config.HMACSecret=${secret}' \
    --data 'config.RSACertificate=/usr/local/kong/ssl/kong-default.crt' \
    --data 'config.RSAPrivateKey=/usr/local/kong/ssl/kong-default.key' \
    --data 'config.algorithm=RS512' \
    --data 'config.authTTL=28800' \
    --data 'config.tokenTTL=28800' \
    --data 'config.denyTokenlessSubmission=false' \
    --data 'config.encrypt=true' \

    #dwp-auth-saml plugin (priority=900)
    curl -i -X POST ${gateway}/$api/plugins/ \
    --data 'name=dwp-auth-saml' \
    --data 'config.xAttributeUsername=http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name' \
    --data 'config.customIssuer=https://wa-nol-prod.service.dwpcloud.uk' \
    --data 'config.xAttributeUserId=http://dwp.gov.uk/dwp_staffid' \
    --data 'config.xAttributeRoles=http://dwp.gov.uk/application_role' \
    --data 'config.pathToListenOn=/nol/login/warning.jsp' \
    --data 'config.digestAlgorithm=sha1' \
    --data 'config.xAuthIndex=5' \
    --data 'config.idpRedirectEndpoint=${config_idpRedirectEndpoint}' \
    --data 'config.disableSignatureValidation=true' \

    #dwp-cis-samltojwt plugin (priority=700)
    curl -X POST ${gateway}/$api/plugins/ \
    --data 'name=dwp-cis-samltojwt' \
    --data 'config.attributeList=http://dwp.gov.uk/dwp_staffid,http://dwp.gov.uk/SLOC,http://dwp.gov.uk/application_role' \

    #dwp-sso-assign plugin (priority=500)
    curl -X POST ${gateway}/$api/plugins/ \
    --data 'name=dwp-sso-assign' 

    #dwp-role-restrict plugin (priority=470)
    curl -X POST ${gateway}/$api/plugins/ \
    --data 'name=dwp-role-restrict' \
    --data 'config.authenticationProvider=dwp-adfs' \
    --data 'config.isWhiteList=true' \
    --data 'config.role=ISCS JSAPS NotificationsOnline' \
    --data 'config.route=/' \

    #dwp-cis-headers plugin (priority=100)
    curl -X POST ${gateway}/$api/plugins/ \
    --data 'name=dwp-cis-headers' \

else
    echo "Non Production - no ADFS"
fi