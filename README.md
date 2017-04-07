# puppet-infoblox
Puppet provider to manage Infoblox DNS entries

# Requirements

- Ruby 2.0

# infoblox_credentials.ini 

to created in puppet conf_dir

  [default]
  username = admin
  password = infoblox
  host = 192.168.110.20

# create a-record
  infoblox_dns_a { 'host.domain.com':
    ensure  => present,
    address => "192.168.0.2"
  }

# create cname 
  infoblox_dns_cname { 'cname.domain.com':
    ensure    => present,
    canonical => 'host.domain.com'
  }
