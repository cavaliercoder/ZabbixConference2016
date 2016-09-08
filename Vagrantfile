# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "zabbix" do |zabbix|
    zabbix.vm.box = "ubuntu/trusty64"
    zabbix.vm.network "public_network", ip: "192.168.64.2"
    zabbix.vm.network "forwarded_port", guest: 80, host: 9000
    zabbix.vm.network "forwarded_port", guest: 10051, host: 10051
    zabbix.vm.provision "shell", path: "vagrant/setup_zabbix.sh"
  end

  config.vm.define "nano" do |nano|
    nano.vm.box = "mwrock/WindowsNano"
    nano.vm.provider "virtualbox" do |vb|
      vb.gui = false
    end

    nano.vm.network "public_network", ip: "192.168.64.3"
  end
end
