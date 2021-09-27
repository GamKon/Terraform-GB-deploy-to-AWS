#!/bin/bash
yum -y update
yum -y install httpd
PrivateIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
PublicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "This server's <br>Public IP: $PublicIP <br>Local  IP: $PrivateIP" > /var/www/html/index.html
service httpd start
chkconfig httpd on