#!/bin/bash
echo "==> Configurando red y NAT..."
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p
DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables-save > /etc/iptables/rules.v4
