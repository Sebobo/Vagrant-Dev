#!/bin/bash

# Copy jenkins plugins into jenkins plugins directory
if [ -d "/var/lib/jenkins/jenkins-data/plugins" ]; then
  cp /vagrant/includes/jenkins-plugins/*.hpi /var/lib/jenkins/jenkins-data/plugins/
fi
