#
# Cookbook:: app_deploy
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
package 'httpd' do
  action :install
end
execute 'mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak' do
  only_if do
    ::File.exist?('/etc/httpd/conf.d/welcome.conf')
  end
  notifies :restart, 'service[httpd]'
end
node['app_deploy']['sites'].each do |sites, data|
  directory "/var/www/#{sites}" do
    mode 0755
    owner 'root'
    group 'root'
    recursive true
  end
  template "/etc/httpd/conf.d/#{sites}.conf" do
    source 'http_conf.erb'
    mode 0644
    owner 'root'
    group 'root'
    variables(port: data['port'], site: sites)
    notifies :restart, 'service[httpd]'
  end
  template "/var/www/#{sites}/index.html" do
    source 'index.html.erb'
    mode 0644
    owner 'root'
    group 'root'
    variables(port: data['port'], site: sites)
  end

  cookbook_file '/etc/selinux/config' do
    source 'selinux_config'
    mode 0644
    owner 'root'
    group 'root'
  end
end

service 'httpd' do
  action [:start, :enable]
end
