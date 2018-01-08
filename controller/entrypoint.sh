#!/bin/bash
# credentials for env setup
export OS_USERNAME=admin
export OS_PASSWORD=openstack
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3

# mysql setup on controller node
echo "Starting MariaDB service..."
service mysql restart
# rabbitmq
echo "Starting RabbitMQ service..." 
service rabbitmq restart
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

mkdir -p /tmp/etcd
tar xzvf /tmp/etcd/etcd-v3.2.7-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1
cp /tmp/etcd/etcd /usr/bin/etcd
cp /tmp/etcd/etcdctl /usr/bin/etcdctl
chown -R nova:nova /etc/nova
chown -R root:glance /etc/glance
chown -R keystone:keystone /etc/keystone
# chown -R horizon:horizon /var/lib/horizon

# keystone
echo "create database keystone;" | mysql
echo "grant all privileges on keystone.* to 'keystone'@'localhost' identified by 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'openshift';" | mysql

su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password openstack \
     --bootstrap-admin-url http://controller:35357/v3/ \
     --bootstrap-internal-url http://controller:5000/v3/ \
     --bootstrap-public-url http://controller:5000/v3/ \
     --bootstrap-region-id RegionOne
# endpoint setup
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password openstack demo
openstack role create user
openstack role add --project demo --user demo user
# glance

echo "create database glance;" | mysql
echo "grant all privileges on glance.* to 'glance'@'localhost' identified by 'openshift';" | mysql
echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'openshift';" | mysql
su -s /bin/sh -c "glance-manage db_sync" glance
service glance-registry restart
service glance-api restart

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
openstack user create --domain default --password openstack nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
openstack user create --domain default --password openstack placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778

# neutron
echo "create database neutron;" | mysql
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'openstack';" | mysql
echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'openstack';" | mysql

openstack user create --domain default --password openstack neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
      --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart

