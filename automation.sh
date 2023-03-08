#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname=prashob
s3_bucket=upgrad-prashob
dir=/var/www/html/
filename=$dir/inventory.html
size=ls -l --b=M  /tmp/${myname}-httpd-logs-${timestamp}.tar | cut -d " " -f5
#asize=$(echo $size)

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


if [ ! -f $filename ]
then
    touch $filename
    echo "Log Type	Time Created	Type	Size" >> '/var/www/html/inventory.html'
else
	echo "httpd-logs	${timestamp}	tar	${size}" >> '/var/www/html/inventory.html'	
fi
