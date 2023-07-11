#!/bin/bash

PIDFILE="/var/log/xlxd.pid"
# Remove pid file if it exists
if [ -e ${PIDFILE} ]; then
  rm ${PIDFILE}
fi

exec /xlxd/xlxd ${XRFNUM} 0.0.0.0 127.0.0.1

RETVAL=${?}
sleep 4
echo `pidof xlxd` > ${PIDFILE}
exit ${RETVAL}