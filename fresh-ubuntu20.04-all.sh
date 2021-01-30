#!/usr/bin/env bash

###WARNING: Please run this script as root user!!!###

#Author: Abrar and Geng
#Version: 1.0

#Description: Post-Install script for Ubunu Systems.

if cat /root/.fresh-install
then
        exit
else
        clear
fi

###Enable root Login###
echo -e "Enabling root login.."
sleep 1
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

###Install Essential Packages###
echo -e "Installing essential packages.."
sleep 1
apt install -y build-essential git
sleep 2
apt install -y screen wget mlocate nmap mtr vim lynx chrony net-tools bind9-utils telnet sysstat firewalld
sleep 2
apt install -y python-dev python-pip python-apt python-dbus usermode qemu-guest-agent
sleep 2
apt install -y freeipa-client oddjob-mkhomedir

###Disable Firewall###
echo -e "Disabling Firewall and allowing Nimsoft.."
sleep 1
ufw status verbose
systemctl stop ufw
systemctl disable ufw
/usr/bin/firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address=172.27.0.79 accept' --permanent
/usr/bin/firewall-cmd --reload
systemctl stop firewalld
systemctl disable firewalld

###Edit ULimit###
echo -e "Editing ULimit.."
sleep 1
echo -e "* hard\tnofile\t64000" >> /etc/security/limits.conf
echo -e "* soft\tnofile\t64000" >> /etc/security/limits.conf

###Disable IPv6###
echo -e "Disable IPv6.."
sleep 1
cp -a /etc/sysctl.conf /etc/sysctl.conf.bak
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

###Install oVirt Guest Agent###
echo -e "Installing oVirt Guest Agent.."
sleep 1
wget http://archive.ubuntu.com/ubuntu/pool/universe/p/python-ethtool/python-ethtool_0.12-1.1_amd64.deb
dpkg -i python-ethtool_0.12-1.1_amd64.deb
sleep 2
wget http://security.ubuntu.com/ubuntu/pool/universe/o/ovirt-guest-agent/ovirt-guest-agent_1.0.13.dfsg-2_all.deb
dpkg -i ovirt-guest-agent_1.0.13.dfsg-2_all.deb

echo "THIS SCRIPT ALREADY RUN BY $(whoami) at $(date)" > /root/.fresh-install

exit 0
