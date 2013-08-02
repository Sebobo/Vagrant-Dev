# Create apc ini file
template "#{node.php.ext_conf_dir}/apc.ini" do
  source "apc/apc.ini.erb"
end
