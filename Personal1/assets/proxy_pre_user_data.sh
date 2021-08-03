
export AWS_DEFAULT_REGION=eu-west-2
export http_proxy=http://${squid_proxy}:3128
export https_proxy=http://${squid_proxy}:3128
export no_proxy=169.254.169.254

# Work around for known RHEL issue with mod-auth-mellon (effects grafana) - advised by HCS Support 18/04/2019
yum install -y yum-versionlock
yum install -y mod_auth_mellon-0.14.0-2.el7
yum versionlock add mod_auth_mellon
# End of workaround