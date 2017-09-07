Puppet::Type.newtype(:infoblox_dns_a) do
  @doc = 'Type representing an Infoblox DNS A Record.'

  ensurable
  newparam(:fqdn) do
    desc 'The FQDN of DNS record.'
    isnamevar
    validate do |value|
      raise 'The name of the record must not be blank' if value.empty?
    end
  end

  newproperty(:ttl) do
    desc 'The time to live for the record.'
    munge do |value|
      value.to_i
    end
    validate do |value|
      raise 'TTL values must be integers' unless value.to_i.to_s == value.to_s
    end
  end

  newproperty(:address) do
    desc 'The IPv4 address for the record.'
    validate do |value|
      raise 'The IPv4 of the record must not be blank' if value.empty?
    end
  end
end
