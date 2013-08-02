
sites = node["projects"]["sites"]

# Create vhosts
sites.each do |site|
  create_site site[:id] do
    document_root site[:document_root]
    create_database site[:create_database]
    action site[:state]
  end
end

# Create default host
global_document_root = '/var/www/default/htdocs'

create_site 'default' do
  server_name node['fqdn']
  document_root global_document_root
  action :enable
end

# Create html file with list of projects
template "#{global_document_root}/index.html" do
  source "pages/sites.html.erb"
  owner node['apache']['user']
  group node['apache']['group']
  mode 0755
  variables(
    :sites => sites,
    :server_name => node['fqdn']
  )
end

# Copy css file to global project
remote_directory global_document_root do
  source "global_site"
  mode 0755
  owner node['apache']['user']
  group node['apache']['group']
  files_mode 0755
  files_owner node['apache']['user']
  files_group node['apache']['group']
end
