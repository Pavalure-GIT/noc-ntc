#!/usr/bin/env bash
yum-config-manager --enable rhui-REGION-rhel-server-rhscl

export PATH=$PATH:/usr/local/bin

yum -y update
yum -y install gcc make git unzip libffi-devel rh-python36 rpm-build rh-ruby24 rh-ruby24-ruby-devel createrepo which
scl enable rh-python36 bash

curl -k https://bootstrap.pypa.io/get-pip.py | python
echo "Download and install Packer... "
curl -sO https://releases.hashicorp.com/packer/1.2.5/packer_1.2.5_linux_amd64.zip
unzip -qo -d /usr/local/bin packer_1.2.5_linux_amd64.zip
ln -s /usr/local/bin/packer /usr/local/bin/packer.io

echo "Download and install Terraform..."
curl -sO https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
unzip -qo -d /usr/local/bin terraform_0.11.13_linux_amd64.zip

export LD_LIBRARY_PATH=/opt/rh/rh-ruby24/root/usr/local/lib64:/opt/rh/rh-ruby24/root/usr/lib64
/opt/rh/rh-ruby24/root/usr/bin/gem install bundle
yum -y install openssl
curl http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --out epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum install -y moreutils

/opt/rh/rh-python36/root/bin/python -m venv /opt/shared-services/terraform/.venv
echo "source /opt/rh/rh-python36/enable" >> /etc/profile.d/dependency.sh
echo "source /opt/rh/rh-ruby24/enable" >> /etc/profile.d/dependency.sh
echo "alias tm=\"ts '%H:%M:%S ▍' | tee -a /opt/release_logs/\`date +%Y-%m-%d.%H-%M-%S\`.log \"" >> ~/.bashrc
echo "alias packer=/usr/local/bin/packer" >> ~/.bashrc
echo "alias terraform=/usr/local/bin/terraform" >> ~/.bashrc

source /etc/profile.d/dependency.sh
pip install fabric3 boto3 pyyaml awscli==1.15.69

if [[ "${ENVIRONMENT}" == "stage" || "${ENVIRONMENT}" == "production" ]]; then
   export ACCOUNT="sre-prod"
else
   export ACCOUNT="sre-dev"
fi

chmod +x /noltf/bin/deploy.sh
/noltf/bin/deploy.sh ${ENVIRONMENT}
