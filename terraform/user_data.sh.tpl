#!/bin/bash

#packages update upgrade and install
sudo apt update -y
sudo apt upgrade -y

# install ansible
sudo apt install python3 -y
sudo apt install ansible -y

until sudo grep "Cloud-init .* finished" /var/log/cloud-init-output.log; do
    echo wait for cloud-init
    sleep 1
done