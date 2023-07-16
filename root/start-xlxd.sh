#!/command/with-contenv bash

PIDFILE="/var/log/xlxd.pid"
XMLFILE="/var/log/xlxd.xml"
IP=$(hostname -I)

# check for modified config files
cp -puv /config/*.* ${XLXD_DIR}

# restore xml file to preserve historical data and allow dashboard to start immediately
cp -puv /config/log/xlxd.xml ${XMLFILE}

# download the dmrid.dat from the XLXAPI server to the xlxd folder
curl -L -s -o ${XLXD_DIR}/dmrid.dat http://xlxapi.rlx.lu/api/exportdmr.php

# start daemon
/xlxd/xlxd ${XRFNUM} ${IP} 127.0.0.1

# Create pid file for service uptime dashboard class
echo `pidof xlxd` > $PIDFILE
