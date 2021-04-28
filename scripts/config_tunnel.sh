# Steen Hegelund
# Time-Stamp: 2021-Apr-23 11:00

WORKIP=10.205.21.59
REMOTEIP=$(ssh work ip addr show dev gtun | grep 'link/gre' | sed -Ee 's/^\s+\S+\s+\S+\s+\S+\s+(\S+)/\1/g')
LOCALIP=$(ip addr show dev cscotun0 | grep 'inet ' | sed -Ee 's/\s+inet\s+(\S+)\/24.*/\1/g')

echo REMOTE: $REMOTEIP
echo LOCAL: $LOCALIP

if [[ $LOCALIP != $REMOTEIP ]]; then
    echo Reconfigure remote tunnel endpoint
    ssh work sudo ip tunnel change gtun remote $LOCALIP
fi

GTUN=$(ip addr show dev gtun 2>/dev/null)
if [[ -z $GTUN ]]; then
    echo Setup local tunnel endpoint
    sudo ip tunnel add gtun mode gre remote $WORKIP local $LOCALIP ttl 255
    sudo ip link set dev gtun up
    sudo ip addr add 11.0.0.2/24 dev gtun
    sudo ip route add 1.0.1.0/24 dev gtun
    sudo ip route add 1.0.2.0/24 dev gtun
    sudo ip route add 1.0.3.0/24 dev gtun
    sudo ip route add 1.0.4.0/24 dev gtun
else
    echo Reuse existing tunnel
fi
