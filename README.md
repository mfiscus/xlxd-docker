# XLXd Docker Image

This Ubuntu Linux based Docker image allows you to run [LX3JL's](https://github.com/LX3JL) [XLXd](https://github.com/LX3JL/xlxd/) without having to configure any files or compile any code.

This is a currently a single-arch image and will only run on amd64 devices.

| Image Tag             | Architectures           | Base Image         | 
| :-------------------- | :-----------------------| :----------------- | 
| latest, ubuntu        | amd64                   | Ubuntu 22.04       | 

## Compatibility

xlxd-docker requires certain variables be defined in your docker run command or docker-compose.yml (recommended) so it can automate the configuration upon bootup.
```bash
CALLSIGN=your_callsign
EMAIL=your@email.com
URL=your_domain.com
XLXNUM=XLX000
```

**For for cross-mode transcoding support you must also run a separate instance of [ambed-docker](https://github.com/mfiscus/ambed-docker)

## Usage

Command Line:

```bash
docker run --name=xlxd -v /opt/xlxd:/config -e "CALLSIGN=your_callsign" -e "EMAIL=your@email.com" -e "URL=your_domain.com" -e "XLXNUM=XLX000" mfiscus/xlxd:latest
```

Using [Docker Compose](https://docs.docker.com/compose/) (recommended):

```yml
version: '3.8'

services:
  xlxd:
    image: mfiscus/xlxd:latest
    container_name: xlxd
    hostname: xlxd_container
    environment:
      # only set CALLHOME to true once your are certain your configuration is correct
      # make sure you backup your callinghome.php file (which should be located on the docker host in /opt/xlxd/) 
      CALLHOME: 'false' 
      CALLSIGN: 'your_callsign'
      EMAIL: 'your@email.com'
      URL: 'your_domain.com'
      PORT: '80'
      XLXNUM: 'XLX000'
      COUNTRY: 'United States'
      DESCRIPTION: 'My xlxd-docker reflector'
      # Define how many modules you require
      MODULES: '4'
      # Name your modules however you like (container only supports naming first 4)
      MODULEA: 'Main'
      MODULEB: 'D-Star'
      MODULEC: 'DMR'
      MODULED: 'YSF'
      TZ: 'UTC'
    networks:
      - proxy
    volumes:
      # local directory where state and config files (including callinghome.php) will be saved
      - /opt/xlxd:/config
    restart: unless-stopped
```

Using [Docker Compose](https://docs.docker.com/compose/) with [ambed-docker](https://github.com/mfiscus/ambed-docker) (support for cross-mode transcoding):

```yml
version: '3.8'

services:
  ambed:
    image: mfiscus/ambed:latest
    container_name: ambed
    hostname: ambed_container
    networks:
      - proxy
    privileged: true
    restart: unless-stopped

  xlxd:
    image: mfiscus/xlxd:latest
    container_name: xlxd
    hostname: xlxd_container
    depends_on:
      ambed:
        condition: service_healthy
        restart: true
    environment:
      # only set CALLHOME to true once your are certain your configuration is correct
      # make sure you backup your callinghome.php file (which should be located on the docker host in /opt/xlxd/) 
      CALLHOME: 'false' 
      CALLSIGN: 'your_callsign'
      EMAIL: 'your@email.com'
      URL: 'your_domain.com'
      PORT: '80'
      XLXNUM: 'XLX000'
      COUNTRY: 'United States'
      DESCRIPTION: 'My xlxd-docker reflector'
      # Define how many modules you require
      MODULES: '4'
      # Name your modules however you like (container only supports naming first 4)
      MODULEA: 'Main'
      MODULEB: 'D-Star'
      MODULEC: 'DMR'
      MODULED: 'YSF'
      TZ: 'UTC'
    networks:
      - proxy
    volumes:
      # local directory where state and config files (including callinghome.php) will be saved
      - /opt/xlxd:/config
    restart: unless-stopped
```

Using [Docker Compose](https://docs.docker.com/compose/) with [ambed-docker](https://github.com/mfiscus/ambed-docker) and [traefik](https://github.com/traefik/traefik) (reverse proxy):

```yml
version: '3.8'

services:
  traefik:
    image: traefik:latest
    container_name: "traefik"
    hostname: traefik_container
    # Enables the web UI and tells Traefik to listen to docker
    command:
      - --api.insecure=true
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      # logging
      - --accesslog=true
      #- --log.level=DEBUG
      - --accesslog.filepath=/var/log/traefik.log
      - --accesslog.bufferingsize=100
      # create entrypoints
      - --entrypoints.www.address=:80/tcp
      - --entrypoints.traefik.address=:8080/tcp
      # xlxd
      - --entrypoints.xlxd-http.address=:80/tcp
      - --entrypoints.xlxd-repnet.address=:8080/udp
      - --entrypoints.xlxd-repnet.udp.timeout=86400s
      - --entrypoints.xlxd-xlxcore.address=:10001/udp
      - --entrypoints.xlxd-xlxcore.udp.timeout=86400s
      - --entrypoints.xlxd-interlink.address=:10002/udp
      - --entrypoints.xlxd-interlink.udp.timeout=86400s
      - --entrypoints.xlxd-ysf.address=:42000/udp
      - --entrypoints.xlxd-ysf.udp.timeout=86400s
      - --entrypoints.xlxd-dextra.address=:30001/udp
      - --entrypoints.xlxd-dextra.udp.timeout=86400s
      - --entrypoints.xlxd-dplus.address=:20001/udp
      - --entrypoints.xlxd-dplus.udp.timeout=86400s
      - --entrypoints.xlxd-dcs.address=:30051/udp
      - --entrypoints.xlxd-dcs.udp.timeout=86400s
      - --entrypoints.xlxd-dmr.address=:8880/udp
      - --entrypoints.xlxd-dmr.udp.timeout=86400s
      - --entrypoints.xlxd-mmdvm.address=:62030/udp
      - --entrypoints.xlxd-mmdvm.udp.timeout=86400s
      - --entrypoints.xlxd-icom-terminal-1.address=:12345/udp
      - --entrypoints.xlxd-icom-terminal-1.udp.timeout=86400s
      - --entrypoints.xlxd-icom-terminal-2.address=:12346/udp
      - --entrypoints.xlxd-icom-terminal-2.udp.timeout=86400s
      - --entrypoints.xlxd-icom-dv.address=:40000/udp
      - --entrypoints.xlxd-icom-dv.udp.timeout=86400s
      - --entrypoints.xlxd-yaesu-imrs.address=:21110/udp
      - --entrypoints.xlxd-yaesu-imrs.udp.timeout=86400s
    ports:
      # traefik ports
      - 80:80/tcp # The www port
      - 8080:8080/tcp # The Web UI (enabled by --api.insecure=true)
      # xlxd ports
      - 80:80/tcp # http
      - 8080:8080/udp # repnet
      - 10001:10001/udp # xlxcore
      - 10002:10002/udp # xlx interlink
      - 42000:42000/udp # ysf
      - 30001:30001/udp # dextra
      - 20001:20001/udp # dplus
      - 30051:30051/udp # dcs
      - 8880:8880/udp # dmr
      - 62030:62030/udp # mmdvm
      - 12345:12345/udp # icom terminal 1
      - 12346:12346/udp # icom terminal 2
      - 40000:40000/udp # icom dv
      - 21110:21110/udp # yaesu imrs
    networks:
      - proxy
    volumes:
      # So that Traefik can listen to the Docker events
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: unless-stopped

  ambed:
    image: mfiscus/ambed:latest
    container_name: ambed
    hostname: ambed_container
    depends_on:
      traefik:
        condition: service_started
    networks:
      - proxy
    privileged: true
    restart: unless-stopped

  xlxd:
    image: mfiscus/xlxd:latest
    container_name: xlxd
    hostname: xlxd_container
    depends_on:
      traefik:
        condition: service_started
      ambed:
        condition: service_healthy
        restart: true
    labels:
      - "traefik.xlxd-http.rule=HostRegexp:your_domain.com,{catchall:.*}"
      - "traefik.xlxd-http.priority=1"
      - "traefik.xlxd-http=xlxd-xlxd-http"
      - "traefik.docker.network=docker_proxy"
      # Explicitly tell Traefik to expose this container
      - "traefik.enable=true"
      # The domain the service will respond to
      - "traefik.http.routers.xlxd-http.rule=Host(`your_domain.com`)"
      # Allow request only from the predefined entry point named "xlxd-http"
      - "traefik.http.routers.xlxd-http.entrypoints=xlxd-http"
      # Specify port xlxd http port
      - "traefik.http.services.xlxd-http.loadbalancer.server.port=80"
      # test alternate http port
      - "traefik.http.routers.xlxd-http.service=xlxd-http"
      # UDP routers
      # repnet
      - "traefik.udp.routers.xlxd-repnet.entrypoints=xlxd-repnet"
      - "traefik.udp.routers.xlxd-repnet.service=xlxd-repnet"
      - "traefik.udp.services.xlxd-repnet.loadbalancer.server.port=8080"
      # xlxcore
      - "traefik.udp.routers.xlxd-xlxcore.entrypoints=xlxd-xlxcore"
      - "traefik.udp.routers.xlxd-xlxcore.service=xlxd-xlxcore"
      - "traefik.udp.services.xlxd-xlxcore.loadbalancer.server.port=10001"
      # xlx interlink
      - "traefik.udp.routers.xlxd-interlink.entrypoints=xlxd-interlink"
      - "traefik.udp.routers.xlxd-interlink.service=xlxd-interlink"
      - "traefik.udp.services.xlxd-interlink.loadbalancer.server.port=10002"
      # xlxd-ysf
      - "traefik.udp.routers.xlxd-ysf.entrypoints=xlxd-ysf"
      - "traefik.udp.routers.xlxd-ysf.service=xlxd-ysf"
      - "traefik.udp.services.xlxd-ysf.loadbalancer.server.port=42000"
      # xlxd-dextra
      - "traefik.udp.routers.xlxd-dextra.entrypoints=xlxd-dextra"
      - "traefik.udp.routers.xlxd-dextra.service=xlxd-dextra"
      - "traefik.udp.services.xlxd-dextra.loadbalancer.server.port=30001"
      # xlxd-dplus
      - "traefik.udp.routers.xlxd-dplus.entrypoints=xlxd-dplus"
      - "traefik.udp.routers.xlxd-dplus.service=xlxd-dplus"
      - "traefik.udp.services.xlxd-dplus.loadbalancer.server.port=20001"
      # dcs
      - "traefik.udp.routers.xlxd-dcs.entrypoints=xlxd-dcs"
      - "traefik.udp.routers.xlxd-dcs.service=xlxd-dcs"
      - "traefik.udp.services.xlxd-dcs.loadbalancer.server.port=30051"
      # dmr
      - "traefik.udp.routers.xlxd-dmr.entrypoints=xlxd-dmr"
      - "traefik.udp.routers.xlxd-dmr.service=xlxd-dmr"
      - "traefik.udp.services.xlxd-dmr.loadbalancer.server.port=8880"
      # mmdvm
      - "traefik.udp.routers.xlxd-mmdvm.entrypoints=xlxd-mmdvm"
      - "traefik.udp.routers.xlxd-mmdvm.service=xlxd-mmdvm"
      - "traefik.udp.services.xlxd-mmdvm.loadbalancer.server.port=62030"
      # icom-terminal-1
      - "traefik.udp.routers.xlxd-icom-terminal-1.entrypoints=xlxd-icom-terminal-1"
      - "traefik.udp.routers.xlxd-icom-terminal-1.service=xlxd-icom-terminal-1"
      - "traefik.udp.services.xlxd-icom-terminal-1.loadbalancer.server.port=12345"
      # icom-terminal-2
      - "traefik.udp.routers.xlxd-icom-terminal-2.entrypoints=xlxd-icom-terminal-2"
      - "traefik.udp.routers.xlxd-icom-terminal-2.service=xlxd-icom-terminal-2"
      - "traefik.udp.services.xlxd-icom-terminal-2.loadbalancer.server.port=12346"
      # icom-dv
      - "traefik.udp.routers.xlxd-icom-dv.entrypoints=xlxd-icom-dv"
      - "traefik.udp.routers.xlxd-icom-dv.service=xlxd-icom-dv"
      - "traefik.udp.services.xlxd-icom-dv.loadbalancer.server.port=40000"
      # yaesu-imrs
      - "traefik.udp.routers.xlxd-yaesu-imrs.entrypoints=xlxd-yaesu-imrs"
      - "traefik.udp.routers.xlxd-yaesu-imrs.service=xlxd-yaesu-imrs"
      - "traefik.udp.services.xlxd-yaesu-imrs.loadbalancer.server.port=21110"
    environment:
      # only set CALLHOME to true once your are certain your configuration is correct
      # make sure you backup your callinghome.php file (which should be located on the docker host in /opt/xlxd/) 
      CALLHOME: 'false' 
      CALLSIGN: 'your_callsign'
      EMAIL: 'your@email.com'
      URL: 'your_domain.com'
      PORT: '80'
      XLXNUM: 'XLX000'
      COUNTRY: 'United States'
      DESCRIPTION: 'My xlxd-docker reflector'
      # Define how many modules you require
      MODULES: '4'
      # Name your modules however you like (container only supports naming first 4)
      MODULEA: 'Main'
      MODULEB: 'D-Star'
      MODULEC: 'DMR'
      MODULED: 'YSF'
      TZ: 'UTC'
    networks:
      - proxy
    volumes:
      # local directory where state and config files (including callinghome.php) will be saved
      - /opt/xlxd:/config
    restart: unless-stopped
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `-v` - maps a local directory used for backing up state and configuration files (including callinghome.php) **required**
* `-e` - used to set environment variables in the container

## License

Copyright (C) 2016 Jean-Luc Deltombe LX3JL and Luc Engelmann LX1IQ 
Copyright (C) 2023 mfiscus

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the [GNU General Public License](./LICENSE) for more details.
