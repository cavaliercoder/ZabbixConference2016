#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# configure message of the day
cat > /etc/motd <<EOL
                            welcome to
 ___________________ ______ ______     ________ _____ __   ________
  ____/|_____||_____]|_____]  |   \___/ |      |     || \  ||______
 /_____|     ||_____]|_____]__|___/   \_|_____ |_____||  \_||      

EOL

# configure environment
sed -i -e 's/#*force_color_prompt=.*/force_color_prompt=yes/' /root/.bashrc
sed -i -e 's/#*force_color_prompt=.*/force_color_prompt=yes/' /home/vagrant/.bashrc
echo "export PATH=/vagrant/mib2zabbix:\$PATH" > /etc/profile.d/mib2zabbix.sh

# configure zabbix repo
wget \
  http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-1+trusty_all.deb
dpkg -i zabbix-release_3.0-1+trusty_all.deb

# configure postgresql repo
echo \
  "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" \
  > /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -

# refresh repos and update all packages
apt-get update && apt-get upgrade -y

# install packages
apt-get install -y \
  dos2unix \
  postgresql-9.5 \
  php5-pgsql \
  pgadmin3 \
  zabbix-server-pgsql \
  zabbix-frontend-php \
  zabbix-agent \
  zabbix-get \
  snmp \
  snmp-mibs-downloader \
  libxml-simple-perl \
  libsnmp-perl \
  tkmib

# configure database
sudo -u postgres psql <<EOL
CREATE ROLE zabbix WITH LOGIN PASSWORD 'zabbix';
CREATE DATABASE zabbix WITH OWNER 'zabbix';
EOL

zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz \
  | sudo -u zabbix psql zabbix

# configure zabbix server
cat >> /etc/zabbix/zabbix_server.conf <<EOL
DBPassword=zabbix
CacheUpdateFrequency=10
EOL

# start zabbix
update-rc.d zabbix-server enable
service zabbix-server start

# install PostgreSQL module
wget http://s3.cavaliercoder.com/libzbxpgsql/apt/zabbix3/ubuntu/trusty/amd64/libzbxpgsql_1.0.0-1%2Btrusty_amd64.deb
dpkg -i libzbxpgsql_1.0.0-1+trusty_amd64.deb

# configure zabbix agent
cat >> /etc/zabbix/zabbix_agentd.conf <<EOL
EnableRemoteCommands=1
EOL

cat > /etc/zabbix/zabbix_agentd.d/demo.conf <<EOL
UserParameter=fork.ping,/bin/echo 1
UserParameter=perl.ping,/usr/bin/perl -e 'print "1\n";'
UserParameter=python.ping,/usr/bin/python -c 'print 1'

EOL

update-rc.d zabbix-agent enable
service zabbix-agent restart

# configure apache
sed -i -e 's/^;*date\.timezone.*/date.timezone = Australia\/Perth/' /etc/php5/apache2/php.ini
service apache2 restart

cat > /etc/zabbix/web/zabbix.conf.php <<EOL
<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'POSTGRESQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '0';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'zabbix';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Vagrant Zabbix';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOL

# configure snmpd
sed -i -e 's/^mibs .*/mibs +ALL/' /etc/snmp/snmp.conf
sed -i \
  -e 's/^#rocommunity public  localhost/ rocommunity public  localhost/' \
  /etc/snmp/snmpd.conf

update-rc.d snmpd enable
service snmpd restart

# install zabbix_agent_bench
wget https://sourceforge.net/projects/zabbixagentbench/files/linux/zabbix_agent_bench-0.4.0.x86_64.tar.gz
tar -xzf zabbix_agent_bench-0.4.0.x86_64.tar.gz
cp -v zabbix_agent_bench-0.4.0.x86_64/zabbix_agent_bench /usr/bin/zabbix_agent_bench

# cleanup
apt-get autoremove -y
