#!/bin/bash

# backup config files
cp -puv /xlxd/*.* /config

TARGET="localhost"
CURL_OPTS="--connect-timeout 15 --max-time 100 --silent --show-error --fail"

curl ${CURL_OPTS} "http://${TARGET}:${PORT}/index.php?callhome=1" >/dev/null
