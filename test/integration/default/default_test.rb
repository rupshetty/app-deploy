# InSpec test for recipe app_deploy::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

#unless os.windows?
  # This is an example test, replace with your own test.
 # describe user('root'), :skip do
  #  it { should exist }
  #end
#end

describe package ('httpd') do
 it {should be_installed}
end

describe file('/etc/httpd/conf.d/welcome.conf') do
 it {should_not exist}
end

describe service('httpd')do
 it {should be_running}
 it {should be_enabled}
end

describe file ('/etc/selinux/config') do
 it {should exist}
 its('content') {should match 'SELINUX=disabled'}
end

# This is an example test, replace it with your own test.
(8081..8085).each do |port|
 describe port(port) do
  it {should be_listening}
end
end
#describe port(80), :skip do
#  it { should_not be_listening }
#end
