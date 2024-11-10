#!/bin/sh
wget -r -p -np -k -P /www/wwwroot/自己域名/work/$2 $1
cp /www/wwwroot/自己域名/readme.txt /www/wwwroot/自己域名/work/$2/readme.txt
cd /www/wwwroot/自己域名/work/$2/
zip -r $2.zip ./
mv $2.zip /www/wwwroot/自己域名/down
rm -rf /www/wwwroot/自己域名/work/$2