
::Chef::Recipe.send(:include, Projects::Apache::VHost)

vhosts = node["projects"]["vhosts"]

vhosts.each do |vhost|
  create_vhost(vhost)
end
