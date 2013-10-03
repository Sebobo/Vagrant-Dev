
if node['php']['ius'] == "5.4"
      packages = %w{ php54-mcrypt }
elsif node['php']['ius'] == "5.3"
      packages = %w{ php53u-mcrypt }
else
      packages = %w{ php-mcrypt }
end

pkgs = value_for_platform(
  [ "centos", "redhat", "fedora", "amazon", "scientific" ] => {
    "default" => packages
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ php5-mcrypt }
  }
)

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "#{node['php']['ext_conf_dir']}/mcrypt.ini" do
  mode "0644"
end
