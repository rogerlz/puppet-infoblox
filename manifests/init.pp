# Installs infoblox gem
class sstk_infoblox {

  package { 'infoblox':
    ensure   => present,
    provider => 'gem',
  }

}
