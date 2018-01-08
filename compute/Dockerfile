FROM ubuntu:16.04
MAINTAINER T. Nichole Williams (tribecca@tribecc.us)

RUN apt -y update && apt -y upgrade
RUN apt -y install software-properties-common && add-apt-repository -y \
    cloud-archive:pike && apt -y update && apt -y dist-upgrade && \
    apt -y install python-pymysql nova-compute sysfsutils ceph-common telnet \
        curl neutron-linuxbridge-agent && \
    apt autoclean && apt autoremove && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nova
RUN mkdir -p /etc/neutron

COPY nova/* /etc/nova/
COPY neutron/* /etc/neutron/
COPY entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/nova/instances"]
ADD entrypoint.sh /
EXPOSE 5900 16509
ENTRYPOINT ["/entrypoint.sh"]
