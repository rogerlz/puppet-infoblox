# Installs infoblox gem
class infoblox {

  package { 'infoblox':
    ensure   => present,
    provider => 'puppet_gem',
  }

}
