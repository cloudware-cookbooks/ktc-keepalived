#
# Cookbook Name:: ktc-keepalived
# Recipe:: default
#

chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "keepalived"
node['keepalived']['instances'].each_pair do |name, instance|
  rewind :keepalived_vrrp => name do
    state node['keepalived']['instance_defaults']['state']
  end
end

