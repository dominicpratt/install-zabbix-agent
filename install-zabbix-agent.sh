#!/bin/bash

# Set some needed variables
PKIIDENTITY=$RANDOM
PSKKEY=$(openssl rand -hex 32)
DEBIANVERSION=$(cat /etc/debian_version)
ZABBIXHOST=""

# Get hostname of Zabbix-Server
if [ -z "$ZABBIXHOST" ]; then
        echo -n "==> Please input the hostname of your Zabbix Monitoring Server... [zabbix.example.org]: "
        read -r ZABBIXHOST
fi

# Get Debian version
if [[ $DEBIANVERSION == *"10"* ]]; then
        wget -q https://repo.zabbix.com/zabbix/4.5/debian/pool/main/z/zabbix-release/zabbix-release_4.5-1%2Bbuster_all.deb -O /tmp/zabbix.deb
elif [[ $DEBIANVERSION == *"9"* ]]; then
        wget -q https://repo.zabbix.com/zabbix/4.5/debian/pool/main/z/zabbix-release/zabbix-release_4.5-1%2Bstretch_all.deb -O /tmp/zabbix.deb
elif [[ $DEBIANVERSION == *"8"* ]]; then
        wget -q https://repo.zabbix.com/zabbix/4.5/debian/pool/main/z/zabbix-release/zabbix-release_4.5-1%2Bjessie_all.deb -O /tmp/zabbix.deb
fi

# Install Zabbix-Repository, then update sources and install Zabbix-Agent and OpenSSL
dpkg -i /tmp/zabbix.deb >/dev/null 2>&1
apt-get -qq update >/dev/null 2>&1
apt-get -qq install zabbix-agent openssl -y >/dev/null 2>&1

# Deploy PSKKEY
echo "$PSKKEY" >/etc/zabbix/zabbix_agentd.psk

# Generate Zabbix-Agent-Configuration
cat <<EOT >/etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=$ZABBIXHOST
ServerActive=$ZABBIXHOST
Hostname=$(hostname -f)
Include=/etc/zabbix/zabbix_agentd.d/*.conf
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=PKI$PKIIDENTITY
TLSPSKFile=/etc/zabbix/zabbix_agentd.psk
EOT

# Show configuration details
echo "The PKI-Identity for this host is: PKI$PKIIDENTITY"
echo "The PSK-Key for this host is: $PSKKEY"

# Restart Zabbix-Agent
service zabbix-agent restart >/dev/null 2>&1
