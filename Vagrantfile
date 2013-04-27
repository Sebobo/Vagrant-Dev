# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provider "virtualbox" do |v|
    v.name = "Jenkins_VM"
    #v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision :chef_solo do |chef|
    # This path will be expanded relative to the project directory
    chef.cookbooks_path = "cookbooks"

    chef.json = {
      "mysql" => {
        "server_root_password" => "worschdsalat",
        "bind_address" => "127.0.0.1",
        "server_debian_password" => "worschdsalat",
        "server_repl_password" => "worschdsalat"
      },
      "couchdb" => {
        "bind_address" => "0.0.0.0"
      },
      "apache" => {
        "default_site_enabled" => true
      }
    }

    chef.add_recipe("apt")
    chef.add_recipe("mysql")
    chef.add_recipe("mysql::server")
    chef.add_recipe("memcached")

    chef.add_recipe("openssl")
    chef.add_recipe("apache2")
    chef.add_recipe("apache2::mod_php5")
    chef.add_recipe("apache2::mod_rewrite")

    chef.add_recipe("php")
    chef.add_recipe("php::module_curl")
    chef.add_recipe("php::module_mysql")
    chef.add_recipe("php::module_memcache")
    chef.add_recipe("php::module_sqlite3")

    chef.add_recipe("imagemagick")
    chef.add_recipe("phantomjs")

    chef.add_recipe("couchdb")
    chef.add_recipe("jenkins::server")
    chef.add_recipe("nodejs-cookbook::install_from_package")
  end

  # Do some post provisioning
  config.vm.provision :shell, :path => "post_provision.sh"

  config.vm.synced_folder "/Users/sebastianhelzle/Workspace", "/var/www"

  config.vm.hostname = "dev.box"
  config.vm.network :private_network, ip: "192.168.164.123"
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network :forwarded_port, host: 4567, guest: 80
  config.vm.network :forwarded_port, host: 5984, guest: 5984, auto_correct: true

end
