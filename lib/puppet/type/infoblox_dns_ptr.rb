Puppet::Type.newtype(:infoblox_dns_ptr) do
  @doc = 'Type representing an Infoblox DNS PTR Record.'

  ensurable
  newparam(:fqdn) do
    desc 'The FQDN of DNS record.'
    isnamevar
    validate do |value|
      raise 'The name of the record must not be blank' if value.empty?
    end
  end

  newproperty(:ptrdname) do
    desc 'The domain name of the DNS PTR record.'
    munge do |value|
      value
    end
    validate do |value|
      raise 'The name of the record must not be blank' if value.empty?
    end
  end

  newproperty(:address) do
    desc 'The IPv4 address for the record.'
    validate do |value|
      raise 'The IPv4 of the record must not be blank' if value.empty?
    end
  end
end
