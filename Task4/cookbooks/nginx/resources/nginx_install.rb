resource_name :nginx_install 

property :version, String, required: true
property :rpm, String, required: true
property :db, String, default: 'Chef Task 4'
property :url, String, required: true
property :path, String, required: true
property :port, String, default: '80'

action :create do 
  remote_file "/tmp/#{new_resource.rpm}" do
    source "#{new_resource.url}"
    action :create_if_missing
  end

  package new_resource.rpm do
    source "/tmp/#{new_resource.rpm}"
    action :install
  end

  service "nginx" do
    action [:enable, :start]
  end

  directory new_resource.path do
    recursive true
    action :create
  end

  template "#{new_resource.path}/index.html" do
    source "index.html.erb"
    mode "0644"
    action :create
    notifies :reload, "service[nginx]"
  end

  template "/etc/nginx/conf.d/jboss.conf'" do
    source "nginx.conf.erb"
    variables(
      ip: search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first,
      port: new_resource.port,
      path: "jboss"
    )
    notifies :reload, "service[nginx]"
  end


end
