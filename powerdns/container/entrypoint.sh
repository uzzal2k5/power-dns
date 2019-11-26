#!/usr/bin/env bash
set -euo pipefail

rm -rf /etc/powerdns/pdns.d/*
cp -rf /container/pdns.local.conf /etc/powerdns/pdns.d/

chown pdns:root /etc/powerdns/pdns.d/pdns.local.conf

exec "$@"
