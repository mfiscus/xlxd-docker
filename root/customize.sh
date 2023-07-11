#!/command/with-contenv sh

### Use environment variables to configure services

# If the first run completed successfully, we are done
if [ -e /.firstRunComplete ]; then
  exit 0
fi

env >/var/log/customize.env

sed -i "s/\(PageOptions\['ContactEmail'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${EMAIL}\'/g" ${XLXCONFIG} # email address
sed -i "s/\(CallingHome\['Country'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"$(echo ${COUNTRY} | awk '{gsub(/ /,"\\ ")}8')\"/g" ${XLXCONFIG} # country
sed -i "s/\(CallingHome\['Comment'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"$(echo ${DESCRIPTION} | awk '{gsub(/ /,"\\ ")}8')\"/g" ${XLXCONFIG} # description
sed -i "s/\(PageOptions\['MetaAuthor'\][[:blank:]]*\=[[:blank:]]*\)'\([[:alnum:]]*\)'/\1\'${CALLSIGN}\'/g" ${XLXCONFIG} # callsign
sed -i "s/\(CallingHome\['MyDashBoardURL'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'http:\/\/${URL}\'/g" ${XLXCONFIG} # URL
sed -i "s/\(CallingHome\['Active'\][[:blank:]]*\=[[:blank:]]*\)[[:alpha:]]*/\1${CALLHOME}/g" ${XLXCONFIG} # call home active
sed -i "s/\(PageOptions\['NumberOfModules'\][[:blank:]]*\=[[:blank:]]*\)[[:digit:]]*/\1${MODULES}/g" ${XLXCONFIG} # number of modules
sed -i "s/\(CallingHome\['HashFile'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"\/xlxd\/callinghome.php\"/g" ${XLXCONFIG}
sed -i "s/\(CallingHome\['LastCallHomefile'\][[:blank:]]*\=[[:blank:]]*\)\"\([[:print:]]*\)\"/\1\"\/xlxd\/lastcallhome.php\"/g" ${XLXCONFIG}
sed -i "s/\(PageOptions\['ModuleNames'\]\['A'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEA}\'/g" ${XLXCONFIG}
sed -i "s/\(PageOptions\['ModuleNames'\]\['B'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEB}\'/g" ${XLXCONFIG}
sed -i "s/\(PageOptions\['ModuleNames'\]\['C'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULEC}\'/g" ${XLXCONFIG}
sed -i "s/\(PageOptions\['ModuleNames'\]\['D'\][[:blank:]]*\=[[:blank:]]*\)'\([[:print:]]*\)'/\1\'${MODULED}\'/g" ${XLXCONFIG}

cat << EOF > /etc/apache2/sites-available/${URL}.conf
<VirtualHost *:80>
    ServerName ${URL}
    DocumentRoot /var/www/xlxd
</VirtualHost>
EOF

echo "ServerName ${URL}" >> /etc/apache2/apache2.conf

a2dissite *default >/dev/null 2>&1
a2ensite ${URL} >/dev/null 2>&1

touch /.firstRunComplete
echo "xlxd first run setup complete"
