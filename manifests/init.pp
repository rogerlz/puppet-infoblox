class infoblox {

  package { 'infoblox':
    ensure => present,
    provider => 'gem',
  }

}
