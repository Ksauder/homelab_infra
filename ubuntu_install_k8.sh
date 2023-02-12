#!/bin/bash
# https://www.howtoforge.com/how-to-setup-kubernetes-cluster-with-kubeadm-on-ubuntu-22-04/
# tested on ubuntu22.04
# run as root

K8_MAJOR=${K8_MAJOR:-1}
K8_MINOR=${K8_MINOR:-25}
K8_PATCH=${K8_PATCH:-1-00}

# prep the box
apt-get update && apt-get upgrade -y
apt-get install -y vim
apt install curl apt-transport-https vim git wget gnupg2 \
    software-properties-common ca-certificates uidmap -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install containerd.io -y
systemctl stop containerd
mv /etc/containerd/config.toml /etc/containerd/config.toml.orig
containerd config default > /etc/containerd/config.toml
# Change the value of cgroup driver "SystemdCgroup = false" to "SystemdCgroup = true".
# This will enable the systemd cgroup driver for the containerd container runtime.
swapoff -a
sed -e '/\/swapfile/ s/^#*/#/' -i /etc/fstab
modprobe overlay
modprobe br_netfilter

# network
cat << EOF | tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# k8 repo
cat << EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt update

# install k8 components
apt-get install -y kubeadm=${K8_MAJOR}.${K8_MINOR}.${K8_PATCH} \
    kubelet=${K8_MAJOR}.${K8_MINOR}.${K8_PATCH} \
    kubectl=${K8_MAJOR}.${K8_MINOR}.${K8_PATCH}
apt-mark hold kubelet kubeadm kubectl

# ready for cluster setup
echo "You should:"
echo "hostnamectl set-hostname k8s-<cp/worker#>"
echo "add a matching entry in /etc/hosts: 127.0.0.1    k8s-<cp/worker#">
echo "If this is a worker, add the cp in /etc/hosts: 10.10.10.10    k8s-cp"
echo "Use kubeadm to init a cluster - steps commented below"
echo "Then install cilium/calico and such"

# Change the value of cgroup driver in containerd/config.toml "SystemdCgroup = false" to "SystemdCgroup = true".
# This will enable the systemd cgroup driver for the containerd container runtime.
# sudo systemctl start containerd
# sudo systemctl enable containerd
# sudo kubeadm init --apiserver-advertise-address <vm_ip> --control-plane-endpoint <vm_hostname> --kubernetes-version 1.25.1 --service-cidr 10.96.0.0/12 --cri-socket=unix:///run/containerd/containerd.sock
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# apply/install calico or cilium
# grow the cluster using kubeadm