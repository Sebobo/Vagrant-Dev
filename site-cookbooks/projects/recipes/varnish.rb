# Copy varnish config
template "/etc/default/varnish" do
  source "varnish/varnish.erb"
end
template "/etc/varnish/default.vcl" do
  source "varnish/default.vcl.erb"
  variables(
    :caching_enabled => node['projects']['varnish']['caching_enabled']
  )
end
