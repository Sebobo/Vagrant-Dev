#
# Cookbook Name:: projects
# Recipe:: default
#
# Copyright 2013, Sebastian Helzle (sebastian@helzle.net)
#
# All rights reserved - Do Not Redistribute
#
::Chef::Recipe.send(:include, PPH::Apache::VHost)

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
  }

  vhosts.push(vhost)
end

node.default["pph_apache"]["vhosts"] = vhosts

include_recipe "pph_apache::default"

# Create html file with list of projects
template "#{node.pph_apache.apache_root_dir}/index.html" do
  source "pages/sites.html.erb"
  variables(
      :params => {
          :vhosts => vhosts,
      }
  )
end
