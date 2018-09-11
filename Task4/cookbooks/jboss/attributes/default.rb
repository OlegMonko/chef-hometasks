default['jboss']['jboss_path'] = '/opt'
default['jboss']['jboss_home'] = "#{node['jboss']['jboss_path']}/jboss"
default['jboss']['jboss_user'] = 'jboss'
default['jboss']['jboss_group'] = 'jboss'
default['jboss']['dl_url'] = "https://kent.dl.sourceforge.net/project/jboss/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip"
default['jboss']['source'] = "https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war"
default['jboss']['deploy'] = "/opt/jboss/server/default/deploy/sample.war"

