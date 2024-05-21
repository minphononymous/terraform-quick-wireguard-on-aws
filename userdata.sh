#!/bin/bash
apt update
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y install docker-ce docker-ce-cli containerd.io

##Install Docker compose##
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -aG docker $USER

##Run Docker compose##
export PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4/)
mkdir -p /opt/myapp
cat <<'EOT' > /opt/myapp/docker-compose.yml
version: "2.1"
services:
  wireguard:
    image: linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - SERVERURL= ${PUBLIC_IP} 
      - SERVERPORT=51820 
      - PEERS=5 
      - PEERDNS=auto
      - INTERNAL_SUBNET=10.13.13.0 
    volumes:
      - /opt/wireguard-server/config:/config
      - /lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped
EOT
cd /opt/myapp && /usr/local/bin/docker-compose up -d
apt install -y qrencode
