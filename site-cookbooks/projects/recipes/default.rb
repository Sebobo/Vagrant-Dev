#
# Cookbook Name:: projects
# Recipe:: default
#
# Copyright 2013, Sebastian Helzle (sebastian@helzle.net)
#
# All rights reserved - Do Not Redistribute
#
vhosts = []

node['projects']['project_list'].each do |project|

  if node['projects']['local']
    project_config = data_bag_item("projects", project)
  else
    project_config = search(:projects, project)
  end

  vhost = {
      :id => project_config["id"],
      :contract_id => project_config["project_name"],
      :server_name => project_config["server_name"],
      :domains => project_config["apache"]["domains"],
      :state => "active",
      :suffix => "",
      :document_root => project_config["apache"]["document_root"],
      :create_database => project_config["mysql"]["create_database"],
  }

  vhosts.push(vhost)
end

node.default["projects"]["vhosts"] = vhosts

include_recipe "apache2"

# Create vhosts
include_recipe "projects::sites"

# Create html file with list of projects
template "#{node.projects.apache_root_dir}/index.html" do
  source "pages/sites.html.erb"
  variables(
      :params => {
          :vhosts => vhosts,
      }
  )
end

cookbook_file "#{node.projects.apache_root_dir}/markdown.css" do
  source "markdown.css"
  mode 00755
end

# Restart apache2 after creating all vhosts
service "apache2" do
  action :restart
end
