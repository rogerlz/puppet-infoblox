Puppet::Type.newtype(:infoblox_dns_host) do
  @doc = 'Type representing an Infoblox DNS Host Record.'

  ensurable
  newparam(:fqdn) do
    desc 'The FQDN of DNS record.'
    isnamevar
    validate do |value|
      raise 'The name of the record must not be blank' if value.empty?
    end
  end

  newproperty(:address, array_matching: :all) do
    desc 'The IPv4 address for the record.'
    validate do |value|
      raise 'The IPv4 of the record must not be blank' if value.empty?
    end
  end
end
