# Installs infoblox gem
class infoblox (
String $infoblox_username = 'infoblox_login',
String $infoblox_password = 'P@ssw0rd1',
String $infoblox_host = 'infoblox.example.com',
) {

  package { 'infoblox':
    ensure   => present,
    provider => 'puppet_gem',
  }

  file { "${settings::confdir}/infoblox_credentials.ini":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => epp('infoblox/infoblox_credentials.epp',{
      username => $infoblox_username,
      password => $infoblox_password,
      host     => $infoblox_host,
    }),
  }
}
