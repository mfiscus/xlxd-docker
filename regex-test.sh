#!/bin/bash

# use gnu variants of sed and grep when on macos
[[ $( uname -s ) == "Darwin" ]] && shopt -s expand_aliases && alias sed="gsed" && alias grep="ggrep"

echo

REFLECTOR_NAME="'C','H','R','C','\ ','R','e','f','l','e','c','t','o','r'"

cat ./root/src/xlxd/src/cysfprotocol.cpp | \
grep "uint8 desc" | \
sed "s/'X','L','X','\ ','r','e','f','l','e','c','t','o','r','\ '/${REFLECTOR_NAME}/g"


echo

YSF_AUTOLINK_ENABLE="1"
cat ./root/src/xlxd/src/main.h | \
grep "YSF_AUTOLINK_ENABLE" | \
sed "s/\(YSF_AUTOLINK_ENABLE[[:blank:]]*\)[[:digit:]]/\1${YSF_AUTOLINK_ENABLE}/g"

echo

YSF_AUTOLINK_MODULE="A"
cat ./root/src/xlxd/src/main.h | \
grep "YSF_AUTOLINK_MODULE" | \
sed "s/\(YSF_AUTOLINK_MODULE[[:blank:]]*\)'[[:alpha:]]'/\1\'${YSF_AUTOLINK_MODULE}\'/g"

echo

YSF_DEFAULT_NODE_RX_FREQ="438000000"
cat ./root/src/xlxd/src/main.h | \
grep "YSF_DEFAULT_NODE_RX_FREQ" | \
sed "s/\(YSF_DEFAULT_NODE_RX_FREQ[[:blank:]]*\)[[:digit:]]*/\1${YSF_DEFAULT_NODE_RX_FREQ}/g"

echo

YSF_DEFAULT_NODE_TX_FREQ="438000000"
cat ./root/src/xlxd/src/main.h | \
grep "YSF_DEFAULT_NODE_TX_FREQ" | \
sed "s/\(YSF_DEFAULT_NODE_TX_FREQ[[:blank:]]*\)[[:digit:]]*/\1${YSF_DEFAULT_NODE_TX_FREQ}/g"

echo

EMAIL="matt@kk7mnz.com"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "your_email" | \
sed "s/\(PageOptions\['ContactEmail'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${EMAIL}\'/g"

echo

COUNTRY="United States"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "your_country" | \
sed "s/\(CallingHome\['Country'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"$(echo ${COUNTRY} | awk '{gsub(/ /,"\\ ")}8')\"/g"

echo

DESCRIPTION="Chandler Ham Radio Club Reflector"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "your_comment" | \
sed "s/\(CallingHome\['Comment'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"$(echo ${DESCRIPTION} | awk '{gsub(/ /,"\\ ")}8')\"/g"

echo

CALLSIGN="KK7MNZ"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "LX1IQ" | \
sed "s/\(PageOptions\['MetaAuthor'\][[:blank:]]*\=[[:blank:]]*\)'\([[:alnum:]]*\)'/\1\'${CALLSIGN}\'/g"

echo

URL="xlx847.kk7mnz.com"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "your_dashboard" | \
sed "s/\(CallingHome\['MyDashBoardURL'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'http:\/\/${URL}\'/g"

echo

CALLHOME="true"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "CallingHome\['Active'\]" | \
sed "s/\(CallingHome\['Active'\][[:blank:]]*\=[[:blank:]]*\)[[:alpha:]]*/\1${CALLHOME}/g"

echo

MODULES="4"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "PageOptions\['NumberOfModules'\]" | \
sed "s/\(PageOptions\['NumberOfModules'\][[:blank:]]*\=[[:blank:]]*\)[[:digit:]]*/\1${MODULES}/g"

echo

cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "CallingHome\['HashFile'\]" | \
sed "s/\(CallingHome\['HashFile'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"\/xlxd\/callinghome.php\"/g"

echo

cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "CallingHome\['LastCallHomefile'\]" | \
sed "s/\(CallingHome\['LastCallHomefile'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"\/xlxd\/lastcallhome.php\"/g"

echo

MODULEA="Main"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "PageOptions\['ModuleNames'\]\['A'\]" | \
sed "s/\(PageOptions\['ModuleNames'\]\['A'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEA}\'/g"

echo


MODULEB="TBD"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "PageOptions\['ModuleNames'\]\['B'\]" | \
sed "s/\(PageOptions\['ModuleNames'\]\['B'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEB}\'/g"

echo

MODULEC="TBD"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "PageOptions\['ModuleNames'\]\['C'\]" | \
sed "s/\(PageOptions\['ModuleNames'\]\['C'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEC}\'/g"

echo

MODULED="TBD"
cat ./root/src/xlxd/dashboard/pgs/config.inc.php | \
grep "PageOptions\['ModuleNames'\]\['D'\]" | \
sed "s/\(PageOptions\['ModuleNames'\]\['D'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULED}\'/g"

echo
