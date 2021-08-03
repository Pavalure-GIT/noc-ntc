#!/usr/bin/env bash
# Used to install Terraform in gitlab CI

yum -y install epel-release unzip
yum -y install python-pip
pip install awscli
echo "Download and install Terraform..."
curl -sO https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
unzip -qo -d /usr/local/bin terraform_0.11.13_linux_amd64.zip
echo "alias terraform=/usr/local/bin/terraform" >> ~/.bashrc
