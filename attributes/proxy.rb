default['drone-docker']['proxy']['domain']         = 'localhost'
default['drone-docker']['proxy']['domain_aliases'] = nil
default['drone-docker']['proxy']['proxy_url']      = 'http://127.0.0.1:8000/'
default['drone-docker']['proxy']['ws_proxy_url']   = 'ws://127.0.0.1:8000/'
default['drone-docker']['proxy']['ssl']            = true
default['drone-docker']['proxy']['data_bag']       = node['drone-docker']['data_bag']
default['drone-docker']['proxy']['data_bag_name']  = 'certificates'
