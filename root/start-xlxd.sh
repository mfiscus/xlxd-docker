#!/command/with-contenv bash

# install config files
cp -vp /config/*.* /xlxd

# start daemon
exec /xlxd/xlxd ${XRFNUM} 0.0.0.0 127.0.0.1
