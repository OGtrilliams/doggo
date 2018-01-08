#!/bin/bash
# mysql setup on controller node

# rabbitmq
rabbitmqctl add_user openstack openstack
sleep 3
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# etcd
groupadd --system etcd
useradd --home-dir "/var/lib/etcd" --system --shell /bin/false \
    -g etcd etcd

mkdir -p /etc/etcd
chown -R etcd:etcd /etc/etcd
mkdir -p /var/lib/etcd
chown -R etcd:etcd /var/lib/etcd

ETCD_VER=v3.2.7
rm -rf /tmp/etcd && mkdir -p /tmp/etcd
curl -L https://github.com/coreos/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1
cp /tmp/etcd/etcd /usr/bin/etcd
cp /tmp/etcd/etcdctl /usr/bin/etcdctl

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





while true
    do sleep 1
done
