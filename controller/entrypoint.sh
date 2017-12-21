#!/bin/bash
# mysql setup on controller node

# keystone
echo "create database keystone;" | mysql
echo "grant all privileges on keystone.* to 'keystone'@'localhost' identified by 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql
# glance

echo "create database glance;" | mysql
echo "grant all privileges on glance.* to 'glance'@'localhost' identified by 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'openshift';" | mysql

# nova
echo "create database nova_api;" | mysql
echo "create database nova;" | mysql
echo "create database nova_cell0;" | mysql
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'openstack';" | mysql
# neutron
echo "create database neutron;" | mysql
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'openstack';" | mysql

# rabbit
while true; do
    if [ "$RABBIT_PASS" ]; then
        rabbitmqctl change_password guest $RABBIT_PASS
        if [ $? == 0 ]; then break
        else echo "Waiting for RabbitMQ Server Password change....";sleep 1
        fi
    fi
done
