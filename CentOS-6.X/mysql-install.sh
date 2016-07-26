#!/bin/sh

if [ ! -f mysql57-community-release-el6-8.noarch.rpm ]; then
  wget http://repo.mysql.com//mysql57-community-release-el6-8.noarch.rpm
fi

rpm -Uvh mysql57-community-release-el6-8.noarch.rpm  

yum --enablerepo=mysql56-community --disablerepo=mysql57-community -y install mysql-server



