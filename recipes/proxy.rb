include_recipe 'apache2'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_wstunnel'

begin
  bag  = node['drone-docker']['proxy']['data_bag']
  name = node['drone-docker']['proxy']['data_bag_name']
  bag_item = Chef::EncryptedDataBagItem.load(bag, name)['content'].to_hash
  node.set['drone-docker']['proxy']['ssl_certificate_file'] = 'ssl/drone-ci.crt'
  node.set['drone-docker']['proxy']['ssl_certificate_key_file'] = 'ssl/drone-ci.key'

  {
    node['drone-docker']['proxy']['ssl_certificate_key_file'] => bag_item['ssl_key'],
    node['drone-docker']['proxy']['ssl_certificate_file']     => bag_item['ssl_certificate'],
  }.each do |filename, payload|
    file File.join(node[:apache][:dir], filename) do
      content payload
      owner 'root'
      group node.apache.root_group
      mode  '0600'
      notifies :restart, 'service[apache2]', :delayed
    end
  end
rescue => e
  Chef::Log.warn "[drone-docker] SSL disabled: #{e}"
  node['drone-docker']['proxy']['ssl'] = false
end

include_recipe 'apache2::mod_ssl' if node['drone-docker']['proxy']['ssl']

Chef::Log.info "Configuring drone vhost"
web_app 'drone-proxy' do
  enable         true
  if node['drone-docker']['proxy']['ssl']
    template     'ssl_proxy.conf.erb'
  else
    template     'proxy.conf.erb'
  end
  server_name    node['drone-docker']['proxy']['domain']
  server_aliases Array(node['drone-docker']['proxy']['domain_aliases'])
  proxy_url      node['drone-docker']['proxy']['proxy_url']
  ws_proxy_url   node['drone-docker']['proxy']['ws_proxy_url']
end
