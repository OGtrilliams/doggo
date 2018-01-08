FROM ubuntu:16.04
MAINTAINER T. Nichole Williams (tribecca@tribecc.us)

RUN apt -y update && apt -y upgrade && apt install -y software-properties-common && add-apt-repository -y cloud-archive:pike
RUN apt -y update && apt -y upgrade
RUN apt -y install mariadb-server python-pmysql python-openstackclient \
    rabbitmq-server memcached python-memcache

COPY entrypoint.sh /entrypoint.sh
RUN mkdir -p /etc/mysql/mariadb.conf.d
COPY mysql/99-openstack.conf /etc/mysql/mariadb.conf.d/99-openstack.conf
COPY etc/memcached.conf /etc/memcached.conf
RUN mkdir -p /etc/etcd
COPY etc/etcd/etcd.conf.yml /etc/etcd/etcd.conf.yml
COPY etcd/tmp/etcd/etcd /usr/bin/etcd*

EXPOSE 3306 35357 9292 5000 5672 8774 8776 6080 9696 80

RUN apt -y install keystone apache2 \
    libapache2-mod-wsgi glance nova-api nova-conductor nova-consoleauth \
    nova-novncproxy nova-scheduler nova-placement-api \
    neutron-server neutron-plugin-ml2 \
    neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
    neutron-metadata-agent
VOLUME ["data"]
ADD entrypoint.sh /
CMD ["/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
