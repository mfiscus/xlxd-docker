#!/bin/bash

# backup config files
cp -puv ${XLXD_DIR}/*.* /config

# backup connection log file
cp -pv /var/log/xlxd.xml /config/log/

TARGET="localhost"
CURL_OPTS="--connect-timeout 15 --max-time 100 --silent --show-error --fail"

curl ${CURL_OPTS} "http://${TARGET}:${PORT}/index.php?callhome=1" >/dev/null
