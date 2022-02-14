#!/bin/bash

#packages update upgrade and install
sudo apt update -y
sudo apt upgrade -y

# install ansible
sudo apt python3 -y
sudo apt python3-pip -y
sudo pip3 install ansible -y