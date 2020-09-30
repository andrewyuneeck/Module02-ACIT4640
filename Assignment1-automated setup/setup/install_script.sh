#!/bin/bash -x -e -u

sudo dnf install -y git

#Change admin group to wheel, and login with admin user
sudo usermod -a -G wheel admin

#Install git, add todoapp user, and clone from github link
sudo useradd todoapp
sudo su- todoapp
git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app

#Download nodes and mongodb
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo dnf install nodejs -y


#Install mongodb process
sudo cp /home/admin/setup/mongodb-org-4.4.repo /etc/yum.repos.d/
sudo dnf install -y mongodb-org
sudo sed 's/CHANGEME/acit4640' /home/todoapp/app/config/database.js
sudo service mongod start

#Make getenforce Permissive and set Selinux disabled to make it consistant
sudo npm install -y /home/todoapp/app
sudo setenforce 0
sudo sed 's/SELINUX=enforcing/SELINUX=disabled' /etc/selinux/config

# Firewall setting (Adding port 8080 and http service)and save
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --zone=public --add-service=http
sudo firewall-cmd --runtime-to-permanent

#Make NodeJS run as a daemon on the VM
sudo cp /home/admin/setup/todoapp.service /etc/systemd/system/

#This is done in the system folder of root
sudo systemctl daemon-reload

#Installing nginx 
sudo dnf install -y epel-release
sudo dnf install -y nginx

#nginx configuration and start
sudo systemctl enable nginx
sudo systemctl start nginx
sudo cp /home/admin/setup/nginx.conf /etc/nginx/
sudo systemctl restart nginx
sudo chmod a+rx /home/todoapp
sudo systemctl restart nginx
sudo systemctl enable todoapp
sudo systemctl start todoapp


