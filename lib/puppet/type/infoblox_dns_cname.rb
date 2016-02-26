Puppet::Type.newtype(:infoblox_dns_cname) do
  @doc = 'Type representing an Infoblox DNS CNAME Record.'

  ensurable
  newparam(:fqdn) do
    desc 'The FQDN of DNS record.'
    isnamevar
    validate do |value|
      fail 'The name of the record must not be blank' if value.empty?
    end
  end

  newproperty(:canonical) do
    desc 'The Canonical address for the record.'
    validate do |value|
      fail 'The Canonical address of the record must not be blank' if value.empty?
    end
  end

end
