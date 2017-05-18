drone-docker
============

Installs Drone CI (>= 0.6) via Docker.

Requirements
------------

You'll need a Docker-compatible Linux kernel.

Attributes
----------

Have a look into the attribute files. You'll get the idea.

Specifically, with the following attributes you can define a data bag
where the cookbook will find Drone environment variables and TLS certificates
for the proxy vhost. Each data bag is expected to have a root key `content`.

```rb
default['drone-docker']['data_bag']      = 'drone-docker'
default['drone-docker']['data_bag_name'] = 'env'
default['drone-docker']['proxy']['data_bag']      = node['drone-docker']['data_bag']
default['drone-docker']['proxy']['data_bag_name'] = 'certificates'
```

The `env` data bag is expected to contain key/value pairs of environment varialbes
to be merged with `node['drone-docker']['volumes']` and passed to Docker.

The `proxy` data bag must contain the two keys `ssl_key` and `ssl_certificate`
which contain the plain ssl key and certificate to be dropped onto the server
for the vhost.

Usage
-----

#### drone-docker::default

Installs Docker and Drone CI.

#### drone-docker::proxy

Sets up Apache and a virtual host which proxies Drone CI.


Just include `drone-docker` in your node's `run_list`:

```rb
{
  'drone-docker' => {
    'data_bag' => 'drone-ci',
    'data_bag_name' => 'env',
    'proxy' => {
      'data_bag_name' => 'certificates',
      'domain' => 'ci.example.com'
    }
  }
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

MIT (see LICENSE file). Written by glaszig@gmail.com.
