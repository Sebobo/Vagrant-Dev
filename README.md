Vagrant-Dev
===========

Vagrant config for my development environment

# Setup projects

Add a json for each project in data_bags/projects.
A vhost will be created for each data_bag in /var/www

# Jenkins config for ySlow

    phantomjs /vagrant/includes//yslow.js -i grade -threshold "B" -f tap http://built-page-here > yslow.tap
