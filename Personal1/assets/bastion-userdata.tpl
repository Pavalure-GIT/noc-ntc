#!/usr/bin/env bash

# Enable ssh access to ec2 instances
cat > /home/ec2-user/.ssh/id_rsa <<EOF
${private_key}
EOF
chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
chmod 400 /home/ec2-user/.ssh/id_rsa

# Enable yum updates through squid proxy
echo "proxy=http://${PROXY_HOST}:${PROXY_PORT}" >> /etc/yum.conf

yum update -y
yum install -y unzip
yum install -y postgresql

curl -s -O ${CW_AGENT_URI}/${CW_AGENT_ZIP_FILE}
unzip ${CW_AGENT_ZIP_FILE}
./install.sh

log "Initialise the logs"

cat << EOF > ${CW_CONFIG}
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/secure",
            "log_group_name": "${LOG_GROUP_NAME}"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "${LOG_GROUP_NAME}"
          }
        ]
      }
    }
  }
}
EOF

systemctl restart amazon-cloudwatch-agent
systemctl enable amazon-cloudwatch-agent

