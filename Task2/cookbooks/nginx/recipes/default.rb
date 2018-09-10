#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
rpm = "nginx-#{node['nginx']['version']}-1.el7.ngx.x86_64.rpm" 
db = data_bag_item('page','simple')

remote_file "/tmp/#{rpm}" do
  source "https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-#{node['nginx']['version']}-1.el7_4.ngx.x86_64.rpm"
  action :create_if_missing
end

package rpm do
  source "/tmp/#{rpm}"
  action :install
end

service "nginx" do
  action [:enable, :start]
end

directory "#{node['nginx']['path']}" do
  recursive true
  action :create
end

template "#{node['nginx']['path']}/index.html" do   
  source "index.html.erb"
  mode "0644"
  action :create
  variables(ct: db)
  notifies :reload, "service[nginx]"
end

template "/etc/nginx/conf.d/jboss.conf'" do   
  source "nginx.conf.erb"
  variables(
    ip: search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first,
    port: node['nginx']['port'],
    path: "jboss" 
  )
  notifies :reload, "service[nginx]"
end
