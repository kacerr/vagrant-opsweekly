#!/bin/bash
echo "create database opsweekly;" | mysql
echo "grant all on opsweekly.* to opsweekly_user@localhost IDENTIFIED BY 'my_password';" | mysql

mysql opsweekly < /srv/www/opsweekly/opsweekly.sql
