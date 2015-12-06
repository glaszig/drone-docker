name             'drone-docker'
maintainer       'glaszig'
maintainer_email 'glaszig@gmail.com'
license          'MIT'
description      'Sets up Drone CI'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'docker'
depends 'apache2', '~> 3.0.0'
