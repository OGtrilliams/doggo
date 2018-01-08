#!/bin/bash
# compute node starter script

service libvirt-bin restart
service nova-compute restart

service nova-compute restart
service neutron-linuxbridge-agent restart
