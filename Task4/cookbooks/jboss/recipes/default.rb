#
# Cookbook:: jboss
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

app_deploy "Deploy" do
  action :deploy
  user node['jboss']['jboss_user'] 
  group node['jboss']['jboss_group']
  url node['jboss']['dl_url']
  home node['jboss']['jboss_home']
  source node['jboss']['source']
  deploy node['jboss']['deploy']
end

