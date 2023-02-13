#!/bin/bash


if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

# make NM ignore CNI stuff
cat << EOF > /etc/NetworkManager/conf.d/rke2-canal.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:flannel*
EOF

curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service

echo 'Next steps to get service running:'
echo 'mkdir -p /etc/rancher/rke2/'
echo 'vim /etc/rancher/rke2/config.yaml'
echo ''
echo 'config.yaml:'
echo 'server: https://<server>:9345'
echo 'token: <token from server node>'
echo ''
echo 'systemctl start rke2-agent.service'
