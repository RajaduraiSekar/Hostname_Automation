#!/bin/bash
# Description
# Change HOSTNAME for each machine from  CSV file
#
# CSV File Format
# Each line contains two columns - mac address & hostname
# Description End
export PATH=$PATH:/home/isl/Desktop/logs.txt
#sed -i -e 's/\r$//' Hostname_New.sh
#Set variable for script
mac_addr= ifconfig eth0 | grep 'inet addr:' | cut -c21-33
network="/etc/sysconfig/network"
network_org="/etc/sysconfig/network.org"
host="/etc/hosts"
#
if [ -r $1 ]; then
  cat $1 |
  while read -r line
  do
    condition="[$mac_addr == $ip]"
    if eval "$condition"; then
       mac=$(ifconfig eth0 | grep 'inet addr:' | cut -c21-33)
       sys_ip=$(awk -F , '$2 == "'$mac'"' | cut -d ',' -f3)
       Hosts_Line="$mac $sys_ip"
       sudo -- sh -c -e "echo 'HOSTNAME=$sys_ip' > /etc/sysconfig/network";
       sudo -- sh -c -e "echo '$Hosts_Line' >> /etc/hosts";
       hostname "$sys_ip"
       echo "Hello buddy!.........>>>>>>Hostname $sys_ip changed with exist IP $mac"
       echo "Hello buddy!.........>>>>>>Hostname $sys_ip changed with exist IP $mac" > output.txt
       break
    else
       echo "IP/Hostname not valid OR IP mismatched"
    fi
    exit
  done < host.csv
fi
