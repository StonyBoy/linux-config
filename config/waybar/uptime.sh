# Steen Hegelund
# Time-Stamp: 2023-Feb-04 18:14
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=sh :

while true ; do
    printf '{"text": "%s", "class": "custom-uptime", "tooltip": "Computer uptime in Days>Hours>Minutes"}\n' $(strict_uptime)
    sleep 60
done
