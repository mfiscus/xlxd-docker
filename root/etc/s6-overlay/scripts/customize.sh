#!/command/with-contenv bash

### Use environment variables to configure services

# If the first run completed successfully, we are done
if [ -e /.firstRunComplete ]; then
  exit 0

fi

# Make sure environment variables are set
if [ -z ${URL:-} ]; then
  echo "URL not set"
  exit 1

fi

# configure dashboard
if [ ! -z ${CALLSIGN:-} ]; then
  sed -i "s/\(PageOptions\['MetaAuthor'\][[:blank:]]*\=[[:blank:]]*\)'\([[:alnum:]]*\)'/\1\'${CALLSIGN}\'/g" ${XLXCONFIG} # callsign

fi

if [ ! -z ${EMAIL:-} ]; then
  sed -i "s/\(PageOptions\['ContactEmail'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${EMAIL}\'/g" ${XLXCONFIG} # email address

fi

sed -i "s/\(CallingHome\['Country'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"$(echo ${COUNTRY} | awk '{gsub(/ /,"\\ ")}8')\"/g" ${XLXCONFIG} # country
sed -i "s/\(CallingHome\['Comment'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"$(echo ${DESCRIPTION} | awk '{gsub(/ /,"\\ ")}8')\"/g" ${XLXCONFIG} # description
sed -i "s/\(CallingHome\['MyDashBoardURL'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'http:\/\/${URL}:${PORT}\/\'/g" ${XLXCONFIG} # URL
sed -i "s/\(CallingHome\['Active'\][[:blank:]]*\=[[:blank:]]*\)[[:alpha:]]*/\1${CALLHOME}/g" ${XLXCONFIG} # call home active
sed -i "s/\(PageOptions\['NumberOfModules'\][[:blank:]]*\=[[:blank:]]*\)[[:digit:]]*/\1${MODULES}/g" ${XLXCONFIG} # number of modules
sed -i "s/\(CallingHome\['HashFile'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"\/xlxd\/callinghome.php\"/g" ${XLXCONFIG}
sed -i "s/\(CallingHome\['LastCallHomefile'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"\/xlxd\/lastcallhome.php\"/g" ${XLXCONFIG} # move callinghome file to /xlxd
sed -i "s/\(PageOptions\['ModuleNames'\]\['A'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEA}\'/g" ${XLXCONFIG} # name module A
sed -i "s/\(PageOptions\['ModuleNames'\]\['B'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEB}\'/g" ${XLXCONFIG} # name module B
sed -i "s/\(PageOptions\['ModuleNames'\]\['C'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEC}\'/g" ${XLXCONFIG} # name module C
sed -i "s/\(PageOptions\['ModuleNames'\]\['D'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULED}\'/g" ${XLXCONFIG} # name module D
sed -i "s/\(PageOptions\['RepeatersPage'\]\['IPModus'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'HideIP\'/g" ${XLXCONFIG} # Hide IP addresses on repeaters page
sed -i "s/\(PageOptions\['PeerPage'\]\['IPModus'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'HideIP\'/g" ${XLXCONFIG} # Hide IP addresses on peer page
sed -i "s/\(PageOptions\['CustomTXT'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1'$(echo ${DESCRIPTION} | awk '{gsub(/ /,"\\ ")}8')'/g" ${XLXCONFIG}
sed -i "s/\(PageOptions\['IRCDDB'\]\['Show'\][[:blank:]]*\=[[:blank:]]*\)[[:alpha:]]*/\1false/g" ${XLXCONFIG}
sed -i "s/d\.m\.Y/m\/d\/Y/g" ${XLXD_WEB_DIR}/pgs/peers.php # convert date format to US
sed -i "s/d\.m\.Y/m\/d\/Y/g" ${XLXD_WEB_DIR}/pgs/repeaters.php # convert date format to US
sed -i "s/d\.m\.Y/m\/d\/Y/g" ${XLXD_WEB_DIR}/pgs/traffic.php # convert date format to US
sed -i "s/d\.m\.Y/m\/d\/Y/g" ${XLXD_WEB_DIR}/pgs/users.php # convert date format to US

# set timezone
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# generate virtual host
cat << EOF > /etc/apache2/sites-available/${URL}.conf
<VirtualHost *:${PORT}>
    ServerName ${URL}
    DocumentRoot /var/www/xlxd
</VirtualHost>
EOF

# Configure default timezone in php
if [ ! -z ${TZ:-} ]; then
  echo "date.timezone = \""${TZ}"\"" >> /etc/php/*/apache2/php.ini

fi

# Configure httpd
echo "Listen ${PORT}" >/etc/apache2/ports.conf
echo "ServerName ${URL}" >> /etc/apache2/apache2.conf

# disable default site(s)
a2dissite *default >/dev/null 2>&1

# enable xlxd dashboard
a2ensite ${URL} >/dev/null 2>&1

touch /.firstRunComplete
echo "xlxd first run setup complete"
