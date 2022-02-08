#!/bin/bash

#packages update upgrade and install
sudo apt update -y
sudo apt upgrade -y
sudo pip install ansible -y


disk=$(lsblk)

#currient ip

getIPUrl="icanhazip.com"
extIP=$(wget -O - -q $getIPUrl);
python_version=$(python3 --version);
ansible_version=$(ansible --version);

#create html file

echo "<h2>Webserver with IP: $extIP</h2><br>Build by Terrafrom!<br>${version}<br>$python_version<br>$ansible_version<br>" > /var/www/html/index.html

#send messages to telegram

curl -s -X POST $URL -d text="текущий ip адресс $extIP"
curl -s -X POST $URL -d text="текущий ip адресс $python_version"
curl -s -X POST $URL -d text="текущий ip адресс $ansible_version"

curl -F document=@"/var/www/html/index.html" $URL2