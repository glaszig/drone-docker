default['drone-docker']['image'] = 'drone/drone'
default['drone-docker']['tag'] = '0.6'
default['drone-docker']['container_name']['server'] = 'drone-server'
default['drone-docker']['container_name']['agent'] = 'drone-agent'
default['drone-docker']['ports'] = %w( 8000:8000 )
default['drone-docker']['cmd_timeout'] = 120
default['drone-docker']['volumes'] = [
  '/opt/docker/drone/lib:/var/lib/drone',
  '/var/run/docker.sock:/var/run/docker.sock'
]
default['drone-docker']['env'] = [
  'DATABASE_DRIVER=sqlite3',
  'DATABASE_CONFIG=/var/lib/drone/drone.sqlite',
  'REMOTE_DRIVER=github'
]
default['drone-docker']['data_bag'] = 'drone-docker'
default['drone-docker']['data_bag_name'] = 'env'
