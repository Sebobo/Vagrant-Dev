#!/usr/bin/env bash
gem install chef --version 11.4.0 --no-rdoc --no-ri --conservative

# Enabled default host
a2ensite default
apache2ctl restart

# Copy jenkins plugins into jenkins plugins directory
cp /vagrant/includes/jenkins-plugins/*.hpi /var/lib/jenkins/jenkins-data/plugins/
