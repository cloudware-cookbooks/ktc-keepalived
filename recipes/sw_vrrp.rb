#
# Cookbook Name:: ktc-keepalived
# Recipe:: sw_vrrp
#

include_recipe "ktc-haproxy"
include_recipe "ktc-keepalived"
haproxy_platform_options = node["haproxy"]["platform"]
listen_ip = rcb_safe_deref(node, "external-vips.rabbitmq-queue")

# first configure the vrrp
Chef::Log.info("Configuring vrrp for #{listen_ip}")
vrrp_name = "vi_#{listen_ip.gsub(/\./, '_')}"
vrrp_interface = get_if_for_net('public', node)
# TODO(anyone): fix this in a way that lets us run multiple clusters in the
#               same broadcast domain.
 # this doesn't solve for the last octect == 255
router_id = listen_ip.split(".")[3].to_i + 1

keepalived_chkscript "haproxy" do
  script "#{haproxy_platform_options["service_bin"]} #{haproxy_platform_options["haproxy_service"]} status"
  interval 5
  action :create
  not_if {File.exists?('/etc/keepalived/conf.d/script_haproxy.conf')}
end

keepalived_vrrp vrrp_name do
  interface vrrp_interface
  virtual_ipaddress Array(listen_ip)
  virtual_router_id router_id  # Needs to be a integer between 1..255
  track_script "haproxy"
  state node['keepalived']['instance_defaults']['state']
  priority node['keepalived']['instance_defaults']['priority']
  notify_master "#{haproxy_platform_options["service_bin"]} haproxy restart"
  notify_backup "#{haproxy_platform_options["service_bin"]} haproxy stop"
  notify_fault "#{haproxy_platform_options["service_bin"]} haproxy stop"
end

