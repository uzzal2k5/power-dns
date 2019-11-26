#!/usr/bin/env bash

set -ex

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
groupadd -r mysql && useradd -r -g mysql mysql

# https://bugs.debian.org/830696 (apt uses gpgv by default in newer releases, rather than gpg)

apt-get update
if ! which gpg; then
	apt-get install -y --no-install-recommends gnupg dirmngr
fi

# Ubuntu includes "gnupg" (not "gnupg2", but still 2.x), but not dirmngr, and gnupg 2.x requires dirmngr
# so, if we're not running gnupg 1.x, explicitly install dirmngr too
if ! gpg --version | grep -q '^gpg (GnuPG) 1\.'; then
	apt-get install -y --no-install-recommends dirmngr
fi
rm -rf /var/lib/apt/lists/*

# add gosu for easy step-down from root
GOSU_VERSION=1.10
GOSU_DEPS='ca-certificates wget'
apt-get update
apt-get install -y --no-install-recommends ${GOSU_DEPS}
rm -rf /var/lib/apt/lists/*

dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"

# verify the signature
export GNUPGHOME="$(mktemp -d)"

#gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
for server in ha.pool.sks-keyservers.net \
              hkp://p80.pool.sks-keyservers.net:80 \
              keyserver.ubuntu.com \
              hkp://keyserver.ubuntu.com:80 \
              pgp.mit.edu; do
    gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || echo "Trying new server..."
done



gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
command -v gpgconf > /dev/null && gpgconf --kill all || :
rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc
chmod +x /usr/local/bin/gosu
# verify that the binary works
gosu nobody true
apt-get purge -y --auto-remove ${GOSU_DEPS}

apt-get update
apt-get install -y --no-install-recommends apt-transport-https ca-certificates
rm -rf /var/lib/apt/lists/*


GPG_KEYS='430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A 4D1BB29D63D98E422B2113B19334A25F8507EFA5'

export GNUPGHOME="$(mktemp -d)"
for key in $GPG_KEYS; do
	#gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"
	for server in ha.pool.sks-keyservers.net \
              hkp://p80.pool.sks-keyservers.net:80 \
              keyserver.ubuntu.com \
              hkp://keyserver.ubuntu.com:80 \
              pgp.mit.edu; do
        gpg --keyserver "$server" --recv-keys "$key" && break || echo "Trying new server..."
    done
done
gpg --export $GPG_KEYS > /etc/apt/trusted.gpg.d/percona.gpg
command -v gpgconf > /dev/null && gpgconf --kill all || :
rm -r "$GNUPGHOME"
apt-key list

echo 'deb https://repo.percona.com/apt stretch main' > /etc/apt/sources.list.d/percona.list


# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
{
    for key in \
        percona-server-server/root_password \
        percona-server-server/root_password_again \
        "percona-server-server-$PERCONA_MAJOR/root-pass" \
        "percona-server-server-$PERCONA_MAJOR/re-root-pass" \
    ; do
        echo "percona-server-server-$PERCONA_MAJOR" "$key" password 'unused'
    done
} | debconf-set-selections
apt-get update
apt-get install -y percona-server-server-$PERCONA_MAJOR
#=$PERCONA_VERSION
rm -rf /var/lib/apt/lists/*

# copy our version of my.cnf
cp /container/percona/my.cnf /etc/mysql/my.cnf

# purge and re-create /var/lib/mysql with appropriate ownership
rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld /var/run/mysqlimport
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/run/mysqlimport
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
chmod 777 /var/run/mysqld /var/run/mysqlimport
touch /var/log/mysql/mysql-slow.log
chown mysql:mysql /var/log/mysql/mysql-slow.log





