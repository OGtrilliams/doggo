FROM centos:latest
MAINTAINER T. Nichole Williams (tribecca@tribecc.us)

RUN yum -y update && yum -y install centos-release-openstack-pike
RUN yum -y install git mariadb-server mariadb
RUN systemctl start mariadb && systemctl enable mariadb
# keystone
RUN echo "create database keystone;" | mysql
RUN echo "grant all privileges on keystone.* to 'keystone'@'localhost' identified by 'openshift';" | mysql && echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql && echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'openshift';" | mysql && echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql
# glance

RUN echo "create database glance;" | mysql
RUN echo "grant all privileges on glance.* to 'glance'@'localhost' identified by 'openshift';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'openshift';" | mysql
# nova

RUN echo "create database nova_api;" | mysql
RUN echo "create database nova;" | mysql
RUN echo "create database nova_cell0;" | mysql
RUN echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'openstack';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'openstack';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'openstack';" | mysql
# neutron
RUN echo "create database neutron;" | mysql
RUN echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'openstack';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'openstack';" | mysql


EXPOSE 3306
