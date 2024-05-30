#!/bin/bash
apt update
apt upgrade -y 
apt install curl wireguard wireguard-tools -y

curl -L https://install.pivpn.io | bash