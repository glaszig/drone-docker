include_recipe 'docker'

execute 'restart container' do
  command 'docker restart drone'
  action :nothing
end

begin
  bag  = node['drone-docker']['data_bag']
  name = node['drone-docker']['data_bag_name']
  bag_item = Chef::EncryptedDataBagItem.load(bag, name)['content'].to_hash
  env_vars = node['drone-docker']['env'].to_a
  bag_item.each { |k, v| env_vars << "#{k}=#{v}" }
  node.set['drone-docker']['env'] = env_vars
rescue => e
  Chef::Log.info "[drone-docker] No env data bag found (#{e.message})"
end

docker_container node['drone-docker']['image'] do
  tag node['drone-docker']['tag']
  container_name node['drone-docker']['container_name']
  port %w( 8000:8000 )
  volume node['drone-docker']['volumes']
  env node['drone-docker']['env']
  detach true
  cmd_timeout node['drone-docker']['cmd_timeout']
end
