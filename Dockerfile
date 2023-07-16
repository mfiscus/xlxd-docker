# syntax=docker/dockerfile:1-labs
FROM amd64/ubuntu:latest AS base

ENTRYPOINT ["/init"]

ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"
ENV CALLSIGN="KK7MNZ" EMAIL="matt@kk7mnz.com" URL="xlx847.kk7mnz.com" XRFNUM="XLX847" PORT=8470
ENV CALLHOME=true COUNTRY="United States" DESCRIPTION="Chandler Ham Radio Club"
ENV MODULES=4 MODULEA="Main" MODULEB="TBD" MODULEC="TBD" MODULED="TBD"
ENV XLXCONFIG=/var/www/xlxd/pgs/config.inc.php
ENV YSF_AUTOLINK_ENABLE=1 YSF_AUTOLINK_MODULE="A" YSF_DEFAULT_NODE_RX_FREQ=438000000 YSF_DEFAULT_NODE_TX_FREQ=438000000
ENV REFLECTOR_NAME="'C','H','R','C','\ ','R','e','f','l','e','c','t','o','r'"
ENV XLXD_DIR=/xlxd XLXD_INST_DIR=/src/xlxd XLXD_WEB_DIR=/var/www/xlxd
ARG ARCH=x86_64 S6_OVERLAY_VERSION=3.1.5.0 S6_RCD_DIR=/etc/s6-overlay/s6-rc.d S6_LOGGING=1 S6_KEEP_ENV=1
ARG AMBED_DIR=/ambed AMBED_INST_DIR=/src/xlxd/ambed
ARG FTDI_INST_DIR=/src/ftdi

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt update && \
    apt upgrade -y && \
    apt install -y \
        apache2 \
        build-essential \
        curl \
        libapache2-mod-php \
        php \
        php-mbstring

# Setup directories
RUN mkdir -p \
    ${AMBED_DIR} \
    ${AMBED_INST_DIR} \
    ${FTDI_INST_DIR} \
    ${XLXD_DIR} \
    ${XLXD_INST_DIR} \
    ${XLXD_WEB_DIR} && \
    chown -R www-data:www-data ${XLXD_DIR}/

# Fetch and extract S6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${ARCH}.tar.xz

# Clone xlxd repository
ADD --keep-git-dir=true https://github.com/LX3JL/xlxd.git#master ${XLXD_INST_DIR}

# Download and extract ftdi driver
# Raspberry Pi (legacy)
#ADD https://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx-arm-v7-hf-1.4.27.tgz /tmp
# Raspberry Pi 4 and up
#ADD https://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx-arm-v8-1.4.27.tgz /tmp
# X64 (working)
#ADD http://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx-${ARCH}-1.4.6.tgz /tmp
# X86 (latest)
ADD https://ftdichip.com/wp-content/uploads/2022/07/libftd2xx-${ARCH}-1.4.27.tgz /tmp
RUN tar -C ${FTDI_INST_DIR} -zxvf /tmp/libftd2xx-${ARCH}-*.tgz

# Copy in source code (use local sources if repositories go down)
#COPY src/ /

# Perform pre-compiliation configurations
RUN sed -i "s/'X','L','X','\ ','r','e','f','l','e','c','t','o','r','\ '/${REFLECTOR_NAME}/g" ${XLXD_INST_DIR}/src/cysfprotocol.cpp && \
    sed -i "1!b;s/\(NB_OF_MODULES[[:blank:]]*\)[[:digit:]]*/\1${MODULES}/g" ${XLXD_INST_DIR}/src/main.h && \
    sed -i "s/\(YSF_AUTOLINK_ENABLE[[:blank:]]*\)[[:digit:]]/\1${YSF_AUTOLINK_ENABLE}/g" ${XLXD_INST_DIR}/src/main.h && \
    sed -i "s/\(YSF_AUTOLINK_MODULE[[:blank:]]*\)'[[:alpha:]]'/\1\'${YSF_AUTOLINK_MODULE}\'/g" ${XLXD_INST_DIR}/src/main.h && \
    sed -i "s/\(YSF_DEFAULT_NODE_RX_FREQ[[:blank:]]*\)[[:digit:]]*/\1${YSF_DEFAULT_NODE_RX_FREQ}/g" ${XLXD_INST_DIR}/src/main.h && \
    sed -i "s/\(YSF_DEFAULT_NODE_TX_FREQ[[:blank:]]*\)[[:digit:]]*/\1${YSF_DEFAULT_NODE_TX_FREQ}/g" ${XLXD_INST_DIR}/src/main.h && \
    cp ${XLXD_INST_DIR}/src/main.h ${XLXD_DIR}/main.h.customized && \
    cp ${XLXD_INST_DIR}/src/cysfprotocol.cpp ${XLXD_DIR}/cysfprotocol.cpp.customized

# Install FTDI driver
RUN cp ${FTDI_INST_DIR}/release/build/libftd2xx.* /usr/local/lib && \
    chmod 0755 /usr/local/lib/libftd2xx.so.* && \
    ln -sf /usr/local/lib/libftd2xx.so.* /usr/local/lib/libftd2xx.so

# Compile and install xlxd
RUN cd ${XLXD_INST_DIR}/src && \
    make clean && \
    make && \
    make install

# Compile and install AMBE server
RUN cd ${AMBED_INST_DIR} && \
    make clean && \
    make && \
    make install && \
    cp ${AMBED_INST_DIR}${AMBED_DIR} ${AMBED_DIR}

# Install web dashboard
RUN cp -ivR ${XLXD_INST_DIR}/dashboard/* ${XLXD_WEB_DIR}/ && \
    chown -R www-data:www-data ${XLXD_WEB_DIR}/

# Copy in custom images and stylesheet
COPY --chown=www-data:www-data custom/up.png ${XLXD_WEB_DIR}/img/up.png
COPY --chown=www-data:www-data custom/down.png ${XLXD_WEB_DIR}/img/down.png
COPY --chown=www-data:www-data custom/header.jpg ${XLXD_WEB_DIR}/img/header.jpg
COPY --chown=www-data:www-data custom/logo.jpg ${XLXD_WEB_DIR}/img/dvc.jpg
COPY --chown=www-data:www-data custom/layout.css ${XLXD_WEB_DIR}/css/layout.css

# Copy in s6 service definitions and scripts
COPY root/ /

# Cleanup
RUN apt -y purge build-essential && \
    apt -y autoremove && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* && \
    rm -rf /src

#TCP port(s) for http(s)
EXPOSE ${PORT}/tcp
#TCP port 8080 (RepNet) optional
EXPOSE 8080/tcp
#UDP port 10001 (json interface XLX Core)
EXPOSE 10001/udp
#UDP port 10002 (XLX interlink)
EXPOSE 10002/udp
#UDP port 42000 (YSF protocol)
EXPOSE 42000/udp
#UDP port 30001 (DExtra protocol)
EXPOSE 30001/udp
#UPD port 20001 (DPlus protocol)
EXPOSE 20001/udp
#UDP port 30051 (DCS protocol)
EXPOSE 30051/udp
#UDP port 8880 (DMR+ DMO mode)
EXPOSE 8880/udp
#UDP port 62030 (MMDVM protocol)
EXPOSE 62030/udp
#UDP port 10100 (AMBE controller port)
EXPOSE 10100/udp
#UDP port 10101 - 10199 (AMBE transcoding port)
EXPOSE 10101-10199/udp
#UDP port 12345 - 12346 (Icom Terminal presence and request port)
EXPOSE 12345-12346/udp
#UDP port 40000 (Icom Terminal dv port)
EXPOSE 40000/udp
#UDP port 21110 (Yaesu IMRS protocol)
EXPOSE 21110/udp

HEALTHCHECK --interval=5s --timeout=2s --retries=20 CMD /healthcheck.sh || exit 1