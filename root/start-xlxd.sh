#!/command/with-contenv bash

PIDFILE="/var/log/xlxd.pid"
XMLFILE="/var/log/xlxd.xml"
IP=$(hostname -I)

# check for modified config files
cp -vp /config/*.* /xlxd

# Create shell xml file so dashboard starts up immediately
cat << EOF > ${XMLFILE}
<?xml version="1.0" encoding="UTF-8"?>
<Version>2.5.3</Version>
<${XRFNUM}  linked peers>
</${XRFNUM}  linked peers>
<${XRFNUM}  linked nodes>
</${XRFNUM}  linked nodes>
<${XRFNUM}  heard users>
</${XRFNUM}  heard users>
EOF

# start daemon
/xlxd/xlxd ${XRFNUM} ${IP} 127.0.0.1

# Create pid file for service uptime dashboard class
echo `pidof xlxd` > $PIDFILE
