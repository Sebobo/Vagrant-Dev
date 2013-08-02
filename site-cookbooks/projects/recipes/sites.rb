
sites = node["projects"]["sites"]

# Create vhosts
sites.each do |site|
  create_site site[:id] do
    document_root site[:document_root]
    create_database site[:create_database]
    action site[:action]
  end
end

# Modify global host
global_document_root = '/var/www/default/htdocs'

# Create html file with list of projects
template "#{global_document_root}/index.html" do
  source "pages/sites.html.erb"
  variables(
    :sites => sites,
    :server_name => node['fqdn'],
  )
end

# Copy css file to global project
remote_directory global_document_root do
  source "global_site"
end
