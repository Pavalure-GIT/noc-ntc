#!/usr/bin/env bash

CW_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
CW_AGENT_URI=https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest
CW_AGENT_ZIP_FILE=AmazonCloudWatchAgent.zip
LOG_GROUP_NAME=HCSBastion

yum update -y
yum install -y unzip

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
