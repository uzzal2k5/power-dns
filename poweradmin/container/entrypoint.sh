#!/usr/bin/env bash
set -e
SESSION_KEY=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`

sed -i -e 's/.*db_host.*/\$db_host = '\"$POWERDB_HOST\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*db_port.*/\$db_port = '\"$POWERDB_PORT\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*db_user.*/\$db_user = '\"$POWERDB_USER\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*db_pass.*/\$db_pass = '\"$POWERDB_PASS\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*db_name.*/\$db_name = '\"$POWERDB_NAME\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*db_type.*/\$db_type = '\"$POWERDB_TYPE\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*dns_ns1.*/\$dns_ns1 = '\"$DNS_NS1\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*dns_ns2.*/\$dns_ns2 = '\"$DNS_NS2\"'\;/g' /var/www/html/config.inc.php
sed -i -e 's/.*session_key.*/\$session_key = '\"$SESSION_KEY\"'\;/g' /var/www/html/config.inc.php
service apache2 start

exec "$@"