#
# Cookbook Name:: projects
# Recipe:: default
#
# Copyright 2013, Sebastian Helzle (sebastian@helzle.net)
#
# All rights reserved - Do Not Redistribute
#

# Collect project configs form databags
vhosts = []

node['projects']['project_list'].each do |project|
  vhosts.push(data_bag_item("projects", project).to_hash())
end

node.default["projects"]["sites"] = vhosts

# Run other recipes
include_recipe "apache2"

include_recipe "projects::sites"
include_recipe "projects::apc"
include_recipe "projects::varnish"
include_recipe "projects::jenkins"

# Restart apache2 after creating all sites
service "apache2" do
  action :restart
end
