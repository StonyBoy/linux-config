# Steen Hegelund
# Time-Stamp: 2021-Mar-05 09:58

REMOTEIP=10.205.29.80
LOCALIP=$(ip addr show dev wan | grep 'inet ' | sed -Ee 's/\s+inet\s+(\S+)\/24.*/\1/g')

echo REMOTE: $REMOTEIP
echo LOCAL: $LOCALIP

ip tunnel add gtun mode gre remote $REMOTEIP local $LOCALIP ttl 255
ip link set dev gtun up
ip addr add 11.0.0.1/24 dev gtun
