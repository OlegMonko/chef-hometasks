resource_name :app_deploy

property :user, String, required: true
property :group, String, required: true
property :url, String, required: true
property :home, String, required: true
property :source, String, required: true
property :deploy, String, required: true 

action :deploy do 
  package 'java-1.8.0-openjdk' do
    action :install
  end

  user new_resource.user do
    shell '/bin/false'
  end

  group new_resource.group do
    action :create
  end

  package 'unzip' do
    action :install
  end

  remote_file '/opt/jboss.zip' do
    source new_resource.url
    owner new_resource.user
    group new_resource.group
    action :create_if_missing
  end
  
  bash 'unzip' do
    code <<-EOH
      mkdir -p /opt/jboss 
      unzip /opt/jboss.zip -d /opt 
      cp -r /opt/jboss-5.1.0.GA/* /opt/jboss/ 
      chown -R jboss:jboss /opt/jboss
      EOH
    not_if { ::File.exist?("#{new_resource.home}/server")}
  end
 
  systemd_unit 'jboss.service' do
    content <<-EOU
      [Unit]
      Description=Jboss Application Server
      After=network.target
      [Service]
      Type=forking
      User=jboss
      Group=jboss
      ExecStart=/bin/bash -c 'nohup /opt/jboss/bin/run.sh -b 192.168.1.52 &'
      ExecStop=/bin/bash -c 'bin/shutdown.sh -s 192.168.1.52 -u admin -p admin'
      [Install]
      WantedBy=multi-user.target
      EOU
    action [ :create, :enable, :start ]
  end

  remote_file new_resource.deploy do
    source new_resource.source
    owner new_resource.user
    group new_resource.group
    show_progress true
    action :create_if_missing
  end
end
