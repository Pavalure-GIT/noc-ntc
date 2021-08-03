exec &> >(tee >(tee /var/log/cloud-init-output.log | logger -t user-data ))

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
hostnamectl set-hostname ${role}-${environment}-$${INSTANCE_ID}
semanage permissive -a firewalld_t

IAC_DIR=/etc/ansible/dwp
mkdir -p $IAC_DIR

# TODO to replace
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
- hosts: all
  roles:
    - prometheus-node-exporter
    - cloudwatch-agent
EOF

yum clean all && yum update -y

if [[ "${configuration}" == "ansible" ]]; then
    if [ ! $(command -v ansible) ]; then
        yum install -y ansible python-pip
        pip install awscli boto botocore boto3 # Yum versions are too old (e.g. no eu-west-2 defined)
    fi

    cat << EOF > $IAC_DIR/common-config.json
${common_config}
EOF

    cat << EOF > /tmp/ansible_rpm_versions.json
${ansible_rpm_versions}
EOF

    yum install -y jq

    # Set the variables for Ansible role versions - will be consumed in the other _user_data.sh fragments
    PROMETHEUS_VERSION=$(jq -r .\"dwp-ansible-prometheus\" /tmp/ansible_rpm_versions.json)
    PROMETHEUS_ALERTMANAGER_VERSION=$(jq -r .\"dwp-ansible-prometheus-alertmanager\" /tmp/ansible_rpm_versions.json)
    PROMETHEUS_NODE_EXPORTER_VERSION=$(jq -r .\"dwp-ansible-prometheus-node-exporter\" /tmp/ansible_rpm_versions.json)
    PROMETHEUS_CLOUDWATCH_EXPORTER_VERSION=$(jq -r .\"dwp-ansible-prometheus-cloudwatch-exporter\" /tmp/ansible_rpm_versions.json)
    PROMETHEUS_BLACKBOX_EXPORTER_VERSION=$(jq -r .\"dwp-ansible-prometheus-blackbox-exporter\" /tmp/ansible_rpm_versions.json)
    PROMETHEUS_PUSHGATEWAY_VERSION=$(jq -r .\"dwp-ansible-prometheus-pushgateway\" /tmp/ansible_rpm_versions.json)
    PROMETHEUS_GRAFANA_SAML_VERSION=$(jq -r .\"dwp-ansible-grafana-saml\" /tmp/ansible_rpm_versions.json)
    CLOUDWATCH_AGENT_VERSION=$(jq -r .\"dwp-ansible-cloudwatch-agent\" /tmp/ansible_rpm_versions.json)

    yum install -y dwp-ansible-prometheus-node-exporter-$${PROMETHEUS_NODE_EXPORTER_VERSION} dwp-ansible-cloudwatch-agent-$${CLOUDWATCH_AGENT_VERSION}
fi
