#!/usr/bin/env /bin/bash

echo
echo "Configuring reflector name"
sed -i "s/\'X\',\'L\',\'X\',\'\ \',\'r\',\'e\',\'f\',\'l\',\'e\',\'c\',\'t\',\'o\',\'r\',\'\ \'/${REFLECTOR_NAME}/g" ${XLXD_INST_DIR}/src/cysfprotocol.cpp

echo "Enabling YSF Autolinking"
sed -i "s/\(YSF_AUTOLINK_ENABLE[[:blank:]]*\)[[:digit:]]/\1${YSF_AUTOLINK_ENABLE}/g" ${XLXD_INST_DIR}/src/main.h

echo "Assigning default YSF Autolink module"
sed -i "s/\(YSF_AUTOLINK_MODULE[[:blank:]]*\)\'[[:alnum:]]\'/\1\'${YSF_AUTOLINK_MODULE}\'/g" ${XLXD_INST_DIR}/src/main.h

echo "Defining YSF node default RX and TX frequencies"
sed -i "s/\(YSF_DEFAULT_NODE_RX_FREQ[[:blank:]]*\)[[:digit:]]*/\1${YSF_DEFAULT_NODE_RX_FREQ}/g" ${XLXD_INST_DIR}/src/main.h
sed -i "s/\(YSF_DEFAULT_NODE_TX_FREQ[[:blank:]]*\)[[:digit:]]*/\1${YSF_DEFAULT_NODE_TX_FREQ}/g" ${XLXD_INST_DIR}/src/main.h
