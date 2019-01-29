#/bin/bash

ALLOWED_IPS="localhost some-server"

for ip in $ALLOWED_IPS
do
    iptables -A INPUT -s $ip -p tcp --destination-port 27017 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -d $ip -p tcp --source-port 27017 -m state --state ESTABLISHED -j ACCEPT
done

iptables -A INPUT -p tcp --destination-port 27017 -j REJECT
