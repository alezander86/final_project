#!/bin/bash

#packages update upgrade and install
sudo apt update -y

# install ansible
sudo apt ansible -y
sudo apt install openjdk-8-jre -y