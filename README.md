# pve-home
## Commands to use


#mounting SMB share as guest on PVE instance
mount -t cifs -o rw,guest,vers=3.0 //192.168.1.4/NAS /mnt/pi 

#binding shares for ctID and PVE dir to CT dir
pct set 100 -mp0 /mnt/pi,mp=/mnt/share