# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 9000

  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive

    # configure message of the day
    cat > /etc/motd <<EOL
                            welcome to
 ___________________ ______ ______     ________ _____ __   ________
  ____/|_____||_____]|_____]  |   \\___/ |      |     || \\  ||______
 /_____|     ||_____]|_____]__|___/   \\_|_____ |_____||  \\_||      

EOL

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
      postgresql-9.5 \
      pgadmin3 \
      zabbix-server-pgsql \
      zabbix-frontend-php \
      zabbix-agent

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
EOL

  # start zabbix
  update-rc.d zabbix-server enable
  service zabbix-server start

  SHELL
end
