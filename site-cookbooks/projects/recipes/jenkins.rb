# Copy jenkins plugins
remote_directory node['jenkins']['server']['data_dir'] + '/plugins/' do
	source 'jenkins'
	recursive true
  action :create_if_missing
end
