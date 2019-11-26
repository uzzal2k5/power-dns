#!/usr/bin/env bash

/usr/bin/mysqldump -uroot -pbrewski01 --single-transaction --routines --databases powerdns > /container/dumps/powerdns-"$(date '+%Y-%m-%d_%H:%M:%S')".sql