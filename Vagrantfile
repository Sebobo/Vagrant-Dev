# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "dev.box"
  config.vm.network :private_network, ip: "192.168.164.123"

  config.vm.synced_folder "~/Workspace", "/var/workspace", :nfs => true

  config.vm.provider "virtualbox" do |v|
    v.name = "Dev.Box"
    v.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision :chef_solo do |chef|
    # This path will be expanded relative to the project directory
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.data_bags_path = "data_bags"
    # chef.nfs = true

    chef.json = {
      "mysql" => {
        "server_root_password" => "worschdsalat",
        "bind_address" => "127.0.0.1",
        "server_debian_password" => "worschdsalat",
        "server_repl_password" => "worschdsalat",
      },
      "projects" => {
        "local" => true,
        "apache_root_dir" => "/var/www",
        "apache_vhosts_config_dir" => "sites-available",
        "project_list" => []
      },
      "couchdb" => {
        "bind_address" => "0.0.0.0",
      },
      "couch_db" => {
        "config" => {
          "httpd" => {
            "bind_address" => "0.0.0.0",
          }
        }
      },
      "apache" => {
        "default_site_enabled" => true,
        "listen_ports" => ["8000"],
      },
    }

    # Merge project list from json file
    chef.json.merge!(JSON.parse(File.read("project-list.json")))

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

    # Setup varnish
    chef.add_recipe "varnish"

    # Setup php
    chef.add_recipe "php"
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

    # Nodejs
    chef.add_recipe "nodejs-cookbook::install_from_package"

    # Add projects
    chef.add_recipe "projects"

    # Jenkins
    # chef.add_recipe "jenkins::server"
  end

  # Do some post provisioning
  config.vm.provision :shell, :path => "post_provision.sh"

end
