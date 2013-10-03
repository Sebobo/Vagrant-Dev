# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "dev.box"
  config.vm.network :private_network, ip: "192.168.164.123"

  config.vm.synced_folder "~/Workspace", "/var/workspace", :nfs => true, :nfs_version => 3

  config.vm.provider "virtualbox" do |v|
    v.name = "Dev.Box"
    v.customize [
      "modifyvm", :id,
      "--memory", 2048,
      "--cpus", 2
    ]
  end

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision :chef_solo do |chef|
    # This path will be expanded relative to the project directory
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.data_bags_path = "data_bags"

    # Merge project list from json file
    chef.json = {}
    chef.json.merge!(JSON.parse(File.read("dev-config.json")))

    # Enable apt-get package
    chef.add_recipe "apt"

    # Setup databases
    chef.add_recipe "mysql"
    chef.add_recipe "mysql::server"
    chef.add_recipe "database::mysql"
    chef.add_recipe "couchdb"

    # Setup apache
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "apache2::mod_rewrite"
    chef.add_recipe "apache2::mod_expires"
    chef.add_recipe "apache2::mod_headers"

    # Setup varnish
    chef.add_recipe "varnish"

    # Setup php
    chef.add_recipe "php"
    chef.add_recipe "php::module_gd"
    chef.add_recipe "php::module_curl"
    chef.add_recipe "php::module_mysql"
    chef.add_recipe "php::module_memcache"
    chef.add_recipe "php::module_sqlite3"
    chef.add_recipe "php::module_apc"

    # Tools
    chef.add_recipe "imagemagick"
    chef.add_recipe "phantomjs"
    chef.add_recipe "memcached"
    chef.add_recipe "openssl"
    chef.add_recipe "redis"

    # Nodejs
    chef.add_recipe "nodejs-cookbook::install_from_package"

    # Add projects
    chef.add_recipe "projects"
    chef.add_recipe "projects::module_mcrypt"

    # Jenkins
    # chef.add_recipe "jenkins::server"
  end

end
