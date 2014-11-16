#
# Cookbook Name:: setup_wordpress
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

####################
# wordpress link
####################

directory node["wordpress"]["install_path"] do
  owner  'apache'
  group  'apache'
  mode   '0755'
  action :create
end

link "#{node["wordpress"]["install_path"]}/#{node["wordpress"]["project_name"]}" do
  owner  'apache'
  group  'apache'
  to "#{node["wordpress"]["project_placed_dir"]}/#{node["wordpress"]["project_name"]}"
  link_type :symbolic
end


############################
# create wordpress database
############################
execute 'create wordpress db' do
  user  'apache'
  group 'apache'
  command  <<-EOH
    mysql -uroot -e "create database #{node["wordpress"]["wp_db_name"]}"
    mysql -uroot -e "grant all privileges on #{node["wordpress"]["wp_db_name"]}.* to #{node["wordpress"]["wp_db_user_name"]}@localhost identified by '#{node["wordpress"]["wp_db_password"]}'"
    mysql -uroot -e "flush privileges"
  EOH
  action :run
end
