#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

nginx_install "Install nginx" do
  action :create
  version lazy {node['nginx']['version']}
  rpm lazy {"nginx-#{node['nginx']['version']}-1.el7.ngx.x86_64.rpm"}
  url lazy {"https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-#{node['nginx']['version']}-1.el7_4.ngx.x86_64.rpm"}
  port lazy {node['nginx']['port']}
  path lazy {node['nginx']['path']}
end

