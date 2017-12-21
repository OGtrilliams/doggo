FROM centos:latest
MAINTAINER T. Nichole Williams (tribecca@tribecc.us)

USER root
RUN yum -y update && yum -y install centos-release-openstack-pike
RUN yum -y install git mariadb-server mariadb
RUN systemctl start mariadb && systemctl enable mariadb
RUN echo "create database keystone;" | mysql
RUN echo "grant all privileges on keystone.* to 'keystone'@'localhost' identified by 'openshift';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql
RUN echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'openshift';" | mysql 
RUN echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql

RUN yum -y install openstack-keystone httpd mod_wsgi
RUN wget -o /etc/keystone/keystone.conf https://raw.githubusercontent.com/OGtrilliams/doggo/master/keystone/keystone.conf

