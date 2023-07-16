#!/usr/bin/env bash  
                                                           
echo "Usb event: $1 $2 $3 $4" >> /tmp/docker_tty.log        
if [ ! -z "$(docker ps -qf name=xlxd)" ]; then
    if [ "$1" == "added" ]; then
        echo "Removing ftdi_sio and usbserial kernel modules"
        /sbin/rmmod ftdi_sio
        /sbin/rmmod usbserial
        echo "Adding $2 to docker" >> /var/log/docker_tty.log
        docker exec -u 0 xlxd mknod $2 c $3 $4
        docker exec -u 0 xlxd chmod -R 777 $2
    else
        echo "Removing $2 from docker" >> /var/log/docker_tty.log
        docker exec -u 0 xlxd rm $2
    fi
fi

# sudo /usr/local/bin/docker_tty.sh 'added' '/dev/ttyUSB0' '188' '0'
# sudo /usr/local/bin/docker_tty.sh 'added' '/dev/ttyUSB1' '188' '1'
