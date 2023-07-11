#!/bin/bash

TARGET="localhost"
CURL_OPTS="--connect-timeout 15 --max-time 100 --silent --show-error --fail"

curl ${CURL_OPTS} "http://${TARGET}:80/" >/dev/null
