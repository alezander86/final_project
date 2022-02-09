#!/bin/bash

#packages update upgrade and install
sudo apt update -y
sudo apt upgrade -y
sudo apt install python3 -y
sudo pip install ansible -y

sudo apt install openjdk-8-jre -y

