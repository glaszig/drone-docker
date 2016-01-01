case node['platform']
when 'debian', 'ubuntu'
  include_recipe 'apt-docker'
when 'redhat', 'centos', 'fedora'
  include_recipe 'yum-docker'
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

docker_installation_package 'default' do
  version node['docker']['version']
  action :create
end

docker_image node['drone-docker']['image'] do
  tag node['drone-docker']['tag']
  action :pull
  notifies :redeploy, "docker_container[#{node['drone-docker']['container_name']}]"
end

docker_container node['drone-docker']['container_name'] do
  repo node['drone-docker']['image']
  tag node['drone-docker']['tag']
  port node['drone-docker']['ports']
  env node['drone-docker']['env']
  binds node['drone-docker']['volumes']
  restart_policy 'always'
end
