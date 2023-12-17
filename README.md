# XLXd Docker Image

This is a fork of https://github.com/mfiscus/xlxd-docker with the intention of using it on ARM (RPI).

This Ubuntu Linux based Docker image allows you to run [LX3JL's](https://github.com/LX3JL) [XLXd](https://github.com/LX3JL/xlxd/) without having to configure any files or compile any code.

This is a currently a single-arch image and will only run on arm64 devices.

| Image Tag             | Architectures           | Base Image         | 
| :-------------------- | :-----------------------| :----------------- | 
| latest, ubuntu        | arm64                   | Ubuntu 22.04       | 

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

## License

Copyright (C) 2016 Jean-Luc Deltombe LX3JL and Luc Engelmann LX1IQ 
Copyright (C) 2023 mfiscus

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the [GNU General Public License](./LICENSE) for more details.
