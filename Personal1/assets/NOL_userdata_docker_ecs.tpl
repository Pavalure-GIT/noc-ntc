export PROXY_PORT=3128
export AWS_DEFAULT_REGION=eu-west-2
export ECS_CLUSTER=nol-ecs-cluster-${tf_workspace_name}
export http_proxy=http://${proxy_host}:$PROXY_PORT
export https_proxy=http://${proxy_host}:$PROXY_PORT
export HTTP_PROXY=http://${proxy_host}:$PROXY_PORT
export HTTPS_PROXY=http://${proxy_host}:$PROXY_PORT
export no_proxy=169.254.169.254
set -xe

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1


echo "**** PMCP Running User Data Script 1"
# Set Yum HTTP proxy
if [ ! -f /var/lib/cloud/instance/sem/config_yum_http_proxy ]; then
	echo "proxy=http://${proxy_host}:$PROXY_PORT" >> /etc/yum.conf
	echo "$$: $(date +%s.%N | cut -b1-13)" > /var/lib/cloud/instance/sem/config_yum_http_proxy
fi

echo "**** PMCP Running User Data Script 2"
#HARDEND IMAGE START

# Install Docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable rhui-REGION-rhel-server-extras
sudo yum install -y container-selinux
sudo yum install -y docker-ce openssl

echo "**** PMCP Running User Data Script 3"

# Disable Selinux
sudo setenforce 0

# Set firewalld rules
sudo chmod 777 /etc/sysctl.conf
echo 'net.ipv4.conf.all.route_localnet = 1' >> /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

echo "**** PMCP Running User Data Script 4"

sudo firewall-cmd --permanent --direct --add-rule ipv4 nat PREROUTING 0 -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat OUTPUT 0 -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679

sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=51678/tcp
sudo firewall-cmd --permanent --add-port=51679/tcp
sudo firewall-cmd --permanent --add-port=3128/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8443/tcp

sudo firewall-cmd --reload

# Create directories for ECS agent
sudo mkdir -p /var/log/ecs /var/lib/ecs/data /etc/ecs

echo "**** PMCP Running User Data Script 5"

# Write ECS config file
cat << EOF > /etc/ecs/ecs.config
ECS_CLUSTER=nol-ecs-cluster-${tf_workspace_name}
ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true
ECS_BACKEND_HOST=
HTTP_PROXY=${proxy_host}:$PROXY_PORT
HTTPS_PROXY=${proxy_host}:$PROXY_PORT
http_proxy=${proxy_host}:$PROXY_PORT
https_proxy=${proxy_host}:$PROXY_PORT
NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock
no_proxy=169.254.169.254,169.254.170.2,/var/run/docker.sock
ECS_DATADIR=/data
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_LOGFILE=/log/ecs-agent.log
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_LOGLEVEL=info
EOF


# Write Docker daemmon http proxy file
sudo mkdir -p /etc/systemd/system/docker.service.d
cat << EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${proxy_host}:$PROXY_PORT/" "NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock"
EOF

# Write Docker daemmon http proxy file
cat << EOF > /etc/systemd/system/docker.service.d/https-proxy.conf
[Service]
Environment="HTTPS_PROXY=http://${proxy_host}:$PROXY_PORT/" "NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock"
EOF

sudo systemctl daemon-reload

# Write systemd unit file
sudo rm -f /etc/systemd/system/docker-container@ecs-agent.service
sudo touch /etc/systemd/system/docker-container@ecs-agent.service
sudo chmod 777 /etc/systemd/system/docker-container@ecs-agent.service
cat << EOF >> /etc/systemd/system/docker-container@ecs-agent.service
[Unit]
Description=Docker Container %I
Requires=docker.service
After=docker.service
[Service]
Restart=always
ExecStartPre=-/usr/bin/docker rm -f %i 
ExecStart=/usr/bin/docker run --name %i \
--privileged \
--restart=on-failure:10 \
--volume=/var/run:/var/run \
--volume=/var/log/ecs/:/log:Z \
--volume=/var/lib/ecs/data:/data:Z \
--volume=/etc/ecs:/etc/ecs \
--net=host \
--env-file=/etc/ecs/ecs.config \
amazon/amazon-ecs-agent:latest
ExecStop=/usr/bin/docker stop %i
[Install]
WantedBy=default.target
EOF

# Start docker
systemctl enable docker
systemctl start docker

# Start ECS Agent
systemctl enable docker-container@ecs-agent.service

systemctl reset-failed docker-container@ecs-agent.service
systemctl start docker-container@ecs-agent.service

# Enable Selinux
#sudo setenforce 1

# END HARDEND IMAGE CONFIG

sudo rm -f /etc/sysconfig/docker
sudo touch /etc/sysconfig/docker
sudo chmod 777 /etc/sysconfig/docker
echo  "export http_proxy=http://${proxy_host}:$PROXY_PORT" >> /etc/sysconfig/docker
echo "export https_proxy=http://${proxy_host}:$PROXY_PORT" >> /etc/sysconfig/docker
echo  "export HTTP_PROXY=http://${proxy_host}:$PROXY_PORT" >> /etc/sysconfig/docker
echo "export HTTPS_PROXY=http://${proxy_host}:$PROXY_PORT" >> /etc/sysconfig/docker
echo "export NO_PROXY=169.254.169.254,169.154.170.2" >> /etc/sysconfig/docker
echo "export no_proxy=169.254.169.254,169.154.170.2" >> /etc/sysconfig/docker

# Set ecs-init HTTP proxy
sudo [ -d /etc/init ] && sudo rm -Rf /etc/init
sudo mkdir /etc/init
sudo chmod 777 -R /etc/init
sudo touch /etc/init/ecs.override
sudo chmod 777 /etc/init/ecs.override
echo "env HTTP_PROXY=${proxy_host}:$PROXY_PORT" >> /etc/init/ecs.override
echo "env HTTPS_PROXY=${proxy_host}:$PROXY_PORT" >> /etc/init/ecs.override
echo "env http_proxy=${proxy_host}:$PROXY_PORT" >> /etc/init/ecs.override
echo "env https_proxy=${proxy_host}:$PROXY_PORT" >> /etc/init/ecs.override
echo "env no_proxy=169.254.169.254,169.254.170.2,/var/run/docker.sock" >> /etc/init/ecs.override 
echo "env NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock" >> /etc/init/ecs.override

sudo systemctl enable docker
sudo systemctl start docker

#service docker restart
sudo systemctl enable docker-container@ecs-agent.service
sudo systemctl start docker-container@ecs-agent.service

#start ecs
NOLNTC_ENV=nol
sudo yum install nano -y
sudo yum install telnet -y

#sudo yum install aws-cli -y
sudo yum install nfs-utils -y

#service httpd start
sudo chmod 777 /etc/hosts

# EFS Mount
sudo [ !  -d /opt/localmount ] && sudo mkdir /opt/localmount
sudo [ !  -d /opt/localmount/audit ] && sudo mkdir /opt/localmount/audit 

sudo chmod -R 777 /opt/localmount/
if grep -qs '/opt/localmount ' /proc/mounts
then 
  sudo echo "nfs alrerady mounted /opt/localmount" 
else 
  sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /opt/localmount
fi 

# Enable Selinux
sudo setenforce 1

echo aws ecr get-login ...
eval "$(aws ecr get-login --no-include-email --region eu-west-2)"
#restart docker
sudo systemctl restart docker

#restart ecs
sudo systemctl restart docker-container@ecs-agent.service

# Enable Selinux
sudo setenforce 1
