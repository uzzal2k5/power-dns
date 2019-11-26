#!/usr/bin/env bash
set -ex
apt-get update
apt-get install -y pdns-server pdns-backend-$backend
apt-get -f purge -y mysql-client
#rm /etc/powerdns/*
#cp -rf /container/pdns..localconf /etc/powerdns/pdns.d/
#chown pdns:root /etc/powerdns/pdns.conf
#pip3 install --no-cache-dir envtpl
