# Copy varnish config
cookbook_file "/etc/default/varnish" do
  source "varnish"
end
cookbook_file "/etc/varnish/default.vcl" do
  source "default.vcl"
end
