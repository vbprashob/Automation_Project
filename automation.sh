#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname=prashob
s3_bucket=upgrad-prashob

echo $timestamp
echo $myname
echo $s3_bucket

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

sudo apt install awscli -y

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
