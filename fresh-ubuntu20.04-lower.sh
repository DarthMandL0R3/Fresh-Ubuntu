#!/bin/bash

###Warning: Please run this script as root user###

#Author: Abrar and Geng.
#Version: 1.1.

#Description: Post-install script for Ubuntu systems.

file="/root/.fresh-install"

if [ ! -f "$file" ]
then
	echo "$0: File '${file}' has not been created. Proceeding with post-install."
else
	echo "$0: File '${file}' has been created. DO NOT PROCEED WITH THIS SCRIPT."
	exit 1
fi

###Update and Upgrade All Packages###
echo "Update all packages.."
echo "---------------------"
apt update && apt upgrade -y
sleep 5s
echo "---------------------"
echo "All packages updated"

###Install Essential Packages###
echo "Installing essential packages.."
echo "-------------------------------"
sleep 5s
apt install -y build-essential git
sleep 5s
apt install -y screen wget mlocate nmap mtr vim lynx chrony net-tools bind9-utils telnet sysstat firewalld
sleep 5s
apt install -y libpython2-stdlib libpython2.7-minimal libpython2.7-stdlib libuser1 python-apt python-dbus python-gi python-is-python2 python2 python2-minimal python2.7 python2.7-minimal qemu-guest-agent usermode
sleep 5s
apt install -y oddjob-mkhomedir
sleep 5s
apt install -y freeipa-client
echo "----------------------------"
echo "Essential packages installed"

###Enable root Login###
echo "Enabling root login.."
echo "---------------------"
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd
sleep 5s
echo "------------------"
echo "Root login enabled"

###Disable Firewall###
echo "Disabling Firewall and allowing Nimsoft.."
echo "-----------------------------------------"
ufw status verbose
systemctl stop ufw
systemctl disable ufw
sleep 5s
/usr/bin/firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address=172.27.0.79 accept' --permanent
/usr/bin/firewall-cmd --reload
systemctl stop firewalld
systemctl disable firewalld
sleep 5s
echo "-----------------"
echo "Firewall Disabled"

###Edit ULimit###
echo "Editing ULimit.."
echo "----------------"
echo "* hard\tnofile\t64000" >> /etc/security/limits.conf
echo "* soft\tnofile\t64000" >> /etc/security/limits.conf
sleep 5s
echo "-------------"
echo "ULimit Edited"

###Disable IPv6###
echo "Disable IPv6.."
echo "--------------"
cp -p /etc/sysctl.conf /etc/sysctl.conf.bak
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
sleep 5s
echo "-------------"
echo "IPv6 Disabled"

###Install oVirt Guest Agent###
echo "Installing oVirt Guest Agent.."
echo "------------------------------"
wget http://archive.ubuntu.com/ubuntu/pool/universe/p/python-ethtool/python-ethtool_0.12-1.1_amd64.deb
dpkg -i python-ethtool_0.12-1.1_amd64.deb
sleep 5s
wget http://security.ubuntu.com/ubuntu/pool/universe/o/ovirt-guest-agent/ovirt-guest-agent_1.0.13.dfsg-2_all.deb
dpkg -i ovirt-guest-agent_1.0.13.dfsg-2_all.deb
sleep 5s
echo "---------------------------"
echo "Ovirt Guest Agent Installed"

echo "THIS SCRIPT ALREADY RUN BY $(whoami) at $(date)" > /root/.fresh-install
sleep 5s

echo "############################################"
echo "The script have been completed successfully."
echo "############################################"

exit 0
