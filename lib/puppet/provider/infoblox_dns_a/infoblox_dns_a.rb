require_relative '../../../puppet_x/infoblox.rb'

Puppet::Type.type(:infoblox_dns_a).provide(:infoblox_dns_a, parent: PuppetX::Infoblox) do
  confine feature: :infoblox

  mk_resource_methods

  def self.instances
    $response = Infoblox::Arecord.all(infoblox_client, _max_results: 9000)
    $response.map do |record|
      new(name: record.name,
          address: record.ipv4addr,
          ensure: :present)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def exists?
    Puppet.info("Infoblox::DNS::A: Checking if A record #{name} exists")
    @property_hash[:ensure] == :present
  end

  def address=(value)
    Puppet.info("Infoblox::DNS::A: Updating A record #{name} with address: #{value}")

    a_record = Infoblox::Arecord.find(infoblox_client, name: name).first
    a_record.ipv4addr = value
    a_record.view = nil
    a_record.put
  end

  def ttl=(value)
    Puppet.info("Infoblox::DNS::A: Updating A record #{name} with TTL: #{value}")

    a_record = Infoblox::Arecord.find(infoblox_client, name: name).first
    a_record.ttl = value
    a_record.view = nil
    a_record.put
  end

  def create
    Puppet.info("Infoblox::DNS::A: Creating A record #{name} with #{resource[:address]}")

    a_record = Infoblox::Arecord.new(
      connection: infoblox_client,
      name: name,
      ipv4addr: @resource[:address],
    )
    a_record.post

    @property_hash[:ensure] = :present
    end

  def destroy
    Puppet.info("Infoblox::DNS::A: Deleting A record #{name}")

    a_record = Infoblox::Arecord.find(infoblox_client, name: name).first
    a_record.delete

    @property_hash[:ensure] = :absent
    end
end
