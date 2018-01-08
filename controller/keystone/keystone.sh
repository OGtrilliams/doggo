#!/bin/bash
# keystone config
#
export OS_AUTH_URL=http://controller:35357/v3
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=openstack
export OS_USER_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3

# identity
openstack project create --domain default --description "Service Project" service

openstack project create --domain default --description "Demo Project" demo

openstack user create --domain default --password-prompt demo

openstack role create user

openstack role add --project demo --user demo user

# glance
openstack user create --domain default --password-prompt glance

openstack role add --project service --user glance admin

openstack service create --name glance --description "OpenStack Image" image

openstack endpoint create --region RegionOne image public http://controller:9292

openstack endpoint create --region RegionOne image internal http://controller:9292

openstack endpoint create --region RegionOne image admin http://controller:9292

# nova

openstack user create --domain default --password-prompt nova

openstack role add --project service --user nova admin

openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1

openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1

openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

openstack user create --domain default --password-prompt placement

openstack role add --project service --user placement admin

openstack service create --name placement --description "Placement API" placement

openstack endpoint create --region RegionOne placement public http://controller:8778

openstack endpoint create --region RegionOne placement internal http://controller:8778

openstack endpoint create --region RegionOne placement admin http://controller:8778
