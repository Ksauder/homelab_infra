#!/bin/bash

# on cp node
sudo kubeadm token create > jointoken.txt
openssl x509 -pubkey \
    -in /etc/kubernetes/pki/ca.crt | openssl rsa \
    -pubin -outform der 2>/dev/null | openssl dgst \
    -sha256 -hex | sed 's/^.* //' > cahash.txt

# worker node
echo "<cp_ip>    <cp_hostname>" >> /etc/hosts
kubeadm join \
    --token $(cat jointoken.txt) \
    <cp_hostname_or_ip>:6443 \
    --discovery-token-ca-cert-hash \
    sha256:$(cat cahash.txt)
