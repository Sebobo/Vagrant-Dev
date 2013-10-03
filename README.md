Vagrant-Dev
===========

Vagrant config for my development environment

# Modify settings

You can overwrite node attributes and the list of active projects by copying `dev-config.json.sample` to `dev-config.json` and editing it.

# Setup projects

Add a json for each project you require in data_bags/projects.
A vhost will be created for each data_bag in /var/www.
The project id has to match the string in the project list in `dev-config.json`.

You have to add each projects url to /etc/hosts so you can access it with your browser:

    192.168.164.123 dev.box myproject.dev.box

# Jenkins config for ySlow

    phantomjs /vagrant/includes//yslow.js -i grade -threshold "B" -f tap http://built-page-here > yslow.tap
