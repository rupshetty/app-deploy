#
# Cookbook:: app_deploy
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

service 'httpd' do
  action [:stop, :disable]
end
package 'httpd' do
  action :remove
end

execute 'rm -rf /etc/httpd/' do
  only_if do
    ::File.exist?('/etc/httpd/')
  end
end
execute 'rm -rf /var/www' do
  only_if do
    ::File.exist?('/var/www')
  end
end
