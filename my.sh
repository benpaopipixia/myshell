#!/bin/bash
sudo ufw disable
sudo service ufw restart
sudo apt-get install -y pptpd
echo "localip 10.100.10.1" >> /etc/pptpd.conf
echo "remoteip 10.100.10.2-100" >> /etc/pptpd.conf
echo "ms-dns 8.8.8.8" >> /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >> /etc/ppp/pptpd-options
echo "abcd pptpd abcd *" >> /etc/ppp/chap-secrets
sudo /etc/init.d/pptpd restart
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
sudo apt-get install -y iptables
sudo iptables -t nat -A POSTROUTING -s 10.100.10.0/24 -o eth0 -j MASQUERADE
sudo iptables-save > /etc/iptables-rules
sudo iptables -A FORWARD -s 10.100.10.0/24 -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1496
sudo service pptpd restart
