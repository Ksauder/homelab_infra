# not sure if these are still accurate https://devopstales.github.io/home/rke2-cilium/#rke2-setup

sudo firewall-cmd --add-port=9345/tcp --permanent
sudo firewall-cmd --add-port=6443/tcp --permanent
sudo firewall-cmd --add-port=10250Air-Gap/tcp --permanent
sudo firewall-cmd --add-port=2379/tcp --permanent
sudo firewall-cmd --add-port=2380/tcp --permanent
sudo firewall-cmd --add-port=30000-32767/tcp --permanent
# Used for the Rancher Monitoring
sudo firewall-cmd --add-port=9796/tcp --permanent
sudo firewall-cmd --add-port=19090/tcp --permanent
sudo firewall-cmd --add-port=6942/tcp --permanent
sudo firewall-cmd --add-port=9091/tcp --permanent
### CNI specific ports
# 4244/TCP is required when the Hubble Relay is enabled and therefore needs to connect to all agents to collect the flows
sudo firewall-cmd --add-port=4244/tcp --permanent
# Cilium healthcheck related permits:
sudo firewall-cmd --add-port=4240/tcp --permanent
sudo firewall-cmd --remove-icmp-block=echo-request --permanent
sudo firewall-cmd --remove-icmp-block=echo-reply --permanent
# Since we are using Cilium with GENEVE as overlay, we need the following port too:
sudo firewall-cmd --add-port=6081/udp --permanent
### Ingress Controller specific ports
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
### To get DNS resolution working, simply enable Masquerading.
sudo firewall-cmd --zone=public  --add-masquerade --permanent

### Finally apply all the firewall changes
sudo firewall-cmd --reload

