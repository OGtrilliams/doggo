FROM ubuntu:16.04
MAINTAINER T. Nichole Williams (tribecca@tribecc.us)

RUN apt -y update && apt -y upgrade && apt install -y software-properties-common && add-apt-repository -y cloud-archive:pike
RUN apt -y update && apt -y upgrade
RUN apt -y install mariadb-server python-pmysql python-openstackclient rabbitmq-server memcached python-memcache
# rabbitmq
RUN rabbitmqctl add_user openstack openstack
RUN rabbitmqctl set_permissions openstack ".*" ".*" ".*"
# memcached

COPY entrypoint.sh /entrypoint.sh
COPY keystone.sh /keystone.sh

CMD ["/entrypoint.sh"]

EXPOSE 3306 35357 9292 5000 5672 8774 8776 6080 9696 80
