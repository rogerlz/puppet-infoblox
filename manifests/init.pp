class infoblox {

  #package { 'inflobox':
  #  ensure => present,
  #  provider puppet_gem
  #}

  # cat infoblox_credentials.ini
  # [default]
  # username = admin
  # password = infoblox
  # host = 192.168.110.20
  #

  infoblox_dns_a { 'host.domain.com':
    ensure  => present,
    address => "192.168.0.2"
  }

  infoblox_dns_cname { 'cname.domain.com':
    ensure    => present,
    canonical => 'host.domain.com'
  }

}
