
#
# Set up Prometheus node exporters (via ansible)
#

export PROXY_PORT=3128
export AWS_DEFAULT_REGION=eu-west-2
export http_proxy=http://${proxy_host}:$PROXY_PORT
export https_proxy=http://${proxy_host}:$PROXY_PORT
export HTTP_PROXY=http://${proxy_host}:$PROXY_PORT
export HTTPS_PROXY=http://${proxy_host}:$PROXY_PORT
export no_proxy=169.254.169.254


semanage permissive -a firewalld_t

IAC_DIR=/etc/ansible/dwp
mkdir -p $IAC_DIR

rpm -U --replacepkgs https://s3.eu-west-2.amazonaws.com/${repository_bucket}/yum-plugin-s3-iam-1.2.2-1.noarch.rpm

cat << EOF > /etc/yum.repos.d/hcs-sre.repo
[hcs-sre-repo]
name=dwp-hcs-sre-repo
baseurl=https://s3-eu-west-2.amazonaws.com/${repository_bucket}/pipeline/
s3_enabled=1
enabled=1
gpgcheck=0
EOF

cat << EOF > $IAC_DIR/site.yaml
---
- hosts: localhost
  roles:
    - prometheus-node-exporter
EOF

if [[ "${configuration}" == "ansible" ]]; then
    if [[ ! $(command -v ansible) ]]; then
        yum install -y ansible python-pip
        pip install awscli boto botocore boto3 # Yum versions are too old (e.g. no eu-west-2 defined)
    fi

    yum install -y jq

    PROMETHEUS_NODE_EXPORTER_VERSION=${dwp-ansible-prometheus-node-exporter-version}

    yum install -y dwp-ansible-prometheus-node-exporter-$${PROMETHEUS_NODE_EXPORTER_VERSION}
fi

cd $IAC_DIR
ansible-playbook site.yaml -c local -i localhost

rm /etc/yum.repos.d/hcs-sre.repo

semanage permissive -d firewalld_t
