#!/bin/bash
#Update packages
apt update
apt upgrade -y
apt dist-upgrade -y

#@TODO: get it from list 
DEBIAN_TEMPLATE=debian-12-standard_12.2-1_amd64.tar.zst
#download debian template
pveam download local $DEBIAN_TEMPLATE

#Crete shared directory to be accesed by containers
mkdir /var/share

#assign ID to containers
CTID_NAS=2001
CTID_SHS=2002
CTID_VPN=2003

echo CTID_NAS: $CTID_NAS 
echo CTID_SHS: $CTID_SHS 
echo CTID_VPN: $CTID_VPN 

#Get root password for containers
echo -n Root password for containers: 
read -s ROOTPASS


#create vpn container for NAS/SAMBA
pct create $CTID_NAS "/var/lib/vz/template/cache/$DEBIAN_TEMPLATE" \
    --hostname nas \
    --memory 2048 \
    --cores 6 \
    --ostype debian \
    --net0 name=eth0,bridge=vmbr0,firewall=0,ip=dhcp,type=veth \
    --storage local-lvm \
    --rootfs local-lvm:8 \
    --unprivileged 1  \
    --password "$ROOTPASS" \
    --mp0 /var/share,mp=/mnt/host-share \
    --onboot 1 

#create vpn container for SmartHomeServer
pct create $CTID_SHS "/var/lib/vz/template/cache/$DEBIAN_TEMPLATE" \
    --hostname shs \
    --memory 2048 \
    --cores 6 \
    --ostype debian \
    --net0 name=eth0,bridge=vmbr0,firewall=0,ip=dhcp,type=veth \
    --storage local-lvm \
    --rootfs local-lvm:8 \
    --unprivileged 1  \
    --password "$ROOTPASS" \
    --mp0 /var/share,mp=/mnt/host-share \
    --onboot 1 

#create vpn container for wireguard
pct create $CTID_VPN "/var/lib/vz/template/cache/$DEBIAN_TEMPLATE" \
    --hostname vpn \
    --memory 2048 \
    --cores 6 \
    --ostype debian \
    --net0 name=eth0,bridge=vmbr0,firewall=0,ip=dhcp,type=veth \
    --storage local-lvm \
    --rootfs local-lvm:8 \
    --unprivileged 1  \
    --password "$ROOTPASS" \
    --mp0 /var/share,mp=/mnt/host-share \
    --onboot 1 


#Starting containers
pct start $CTID_NAS
pct start $CTID_SHS
pct start $CTID_VPN