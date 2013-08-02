define :create_site, :create_database => false, :action => :enable do
  apache_root_dir = '/var/www'
  apache_vhosts_config_dir = node['apache']['dir'] + '/sites-available'

  vhost_id = params[:name]
  vhost_basedir = apache_root_dir + '/' + vhost_id
  vhost_config_file = "#{apache_vhosts_config_dir}/#{vhost_id}.conf"
  vhost_server_name = params[:server_name] || (vhost_id + '.' + node['fqdn'])

  log "Running action #{params[:action]} on vhost #{vhost_id}"

  case params[:action]

    when :enable

      #############################
      # Create site directories
      #############################

      %w{ / etc htdocs log }.each do |dir|
        directory "#{vhost_basedir}/#{dir}" do
          mode 0755
          owner node['apache']['user']
          group node['apache']['group']
          action :create
        end
      end

      #############################
      # Create vhost
      #############################

      template vhost_config_file do
        source "apache/vhost.conf.erb"
        notifies :reload, "service[apache2]"
        variables(
          :server_name => vhost_server_name,
          :vhost_basedir => vhost_basedir,
          :document_root => params[:document_root] || "#{vhost_basedir}/htdocs"
        )
      end

      #############################
      # Create database if required
      #############################
      if params[:create_database]
        mysql_database "#{vhost_id}" do
          connection ({
            :host => "localhost",
            :username => 'root',
            :password => node['mysql']['server_root_password']
          })
          action :create
        end
      end

      apache_site "#{vhost_id}.conf" do
        enable true
      end

    when :disabled

      directory vhost_basedir do
        action :delete
        recursive true
      end

      file vhost_config_file do
        action :delete
      end

    else
      log "Log unknown action '#{params[:action]}' for vhost #{vhost_id}" do
        level :error
      end

  end
end
