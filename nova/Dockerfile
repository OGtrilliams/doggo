FROM centos7:latest
MAINTAINER T. Nichole Williams (tribecca@tribecc.us)

RUN yum -y update && yum -y install centos-release-openstack-pike
RUN yum -y install git mariadb-server mariadb
RUN systemctl start mariadb && systemctl enable mariadb
echo "grant all privileges on nova_api.* to 'nova'@'localhost' identified by 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'openshift';" | mysql 
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';" | mysql
