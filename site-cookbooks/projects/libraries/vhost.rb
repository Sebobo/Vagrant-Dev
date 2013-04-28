# define a module to mix into Chef::Recipe::namespace
module Projects
  module Apache
    module VHost
      def create_vhost(vhost)
        id = vhost[:id]
        contract_id = vhost[:contract_id]
        apache_root_dir = node['projects']['apache_root_dir']
        apache_vhosts_config_dir = node['projects']['apache_vhosts_config_dir']
        user_dir = "#{apache_root_dir}/#{contract_id}"
        suffix = vhost[:suffix]
        current_server = vhost[:server_name]
        domains = vhost[:domains]
        state = vhost[:state]

        if vhost[:document_root]
          document_root = vhost[:document_root]
        else
          document_root = "#{user_dir}/htdocs"
        end

        log "[#{contract_id}] VHost:#{state} domains #{domains.join(', ')}"

        case state

          when "active"

            default_vhost_name = "#{contract_id}.#{current_server}"

            #############################
            # system config
            #############################

            group contract_id

            user contract_id do
              group contract_id
            end

            #############################
            # apache config
            #############################

            template "#{node.apache.dir}/#{apache_vhosts_config_dir}/#{contract_id}.conf" do
              source "apache/vhost.conf.erb"
              notifies :reload, "service[apache2]"
              variables(
                  :params => {
                      :server_name => default_vhost_name,
                      :server_aliases => domains,
                      :contract_id => contract_id,
                      :apache_root_dir => apache_root_dir,
                      :document_root => document_root
                  }
              )
            end

            directory "#{node.apache.dir}/protect.d/#{contract_id}" do
              action :create
              recursive true
            end

            #############################
            # /var/apache things
            #############################

            directory "#{user_dir}" do
              mode 0750
              owner contract_id
              group contract_id
              action :create
              recursive true
            end

            %w{ / cgi-bin etc fcgi-bin htdocs log sbin sql }.each do |dir|
              directory "#{user_dir}/#{dir}" do
                owner contract_id
                group contract_id
                action :create
              end
            end

            template "#{user_dir}/fcgi-bin/php-wrapper" do
              source "php/php-wrapper.erb"
              mode 0750
              owner contract_id
              group contract_id
            end


            apache_site "#{contract_id}.conf" do
              enable true
            end

            # Add user vagrant to new group
            group "#{contract_id}" do
              action :modify
              members "vagrant"
              append true
            end

          when "disabled"

            template "#{node.apache.dir}/protect.d/#{contract_id}/disable-site.conf" do
              source "apache/protect.d/disable-site.conf"
            end


          when "deleted"

            group contract_id do
              action :remove
            end

            user contract_id do
              action :remove
            end

            directory user_dir do
              action :delete
              recursive true
            end

            directory "#{node.apache.dir}/#{apache_vhosts_config_dir}"

            file "#{node.apache.dir}/#{apache_vhosts_config_dir}/#{contract_id}.conf" do
              action :delete
            end

          else
            log "Log unknown action '#{state}' for id #{id} (contract:#{contract_id})" do
              level :error
            end

        end
      end
    end
  end
end
