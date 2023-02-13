#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

apt install curl -y

# make NM ignore CNI stuff
cat << EOF > /etc/NetworkManager/conf.d/rke2-canal.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:flannel*
EOF
systemctl reload NetworkManager

# install
curl -sfL https://get.rke2.io | sh -
cat << EOF > /etc/rancher/rke2/config.yaml
cni: "cilium"
EOF

systemctl enable rke2-server.service
systemctl start rke2-server.service

# add to PATH var for rke2 bins
echo 'export PATH="$PATH:/var/lib/rancher/rke2/bin/"' >> ~/.bashrc

# notes
echo "Two cleanup scripts will be installed to the path at /usr/local/bin/rke2. They are: rke2-killall.sh and rke2-uninstall.sh"
echo "A kubeconfig file will be written to /etc/rancher/rke2/rke2.yaml"
echo "A token that can be used to register other server or agent nodes will be created at /var/lib/rancher/rke2/server/node-token"
