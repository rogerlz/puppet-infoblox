# Installs infoblox gem
class infoblox (
  Optional[String] $source = undef,
  Optional[Array] $install_options = undef,
) {

  package { 'infoblox':
    ensure          => present,
    provider        => 'puppet_gem',
    source          => $source,
    install_options => $install_options,
  }

}
