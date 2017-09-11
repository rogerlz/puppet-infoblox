require_relative '../../../puppet_x/infoblox.rb'

Puppet::Type.type(:infoblox_dns_host).provide(:infoblox_dns_host, parent: PuppetX::Infoblox) do
  confine feature: :infoblox

  mk_resource_methods

  def self.instances
    $response = Infoblox::Host.all(infoblox_client, _max_results: 9000)
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
    Puppet.info("Infoblox::DNS::Host: Checking if Host record #{name} exists")
    @property_hash[:ensure] == :present
  end

  def address=(value)
    Puppet.info("Infoblox::DNS::Host: Updating Host record #{name} with address: #{value}")

    host_record = Infoblox::Host.find(infoblox_client, name: name).first
    host_record.ipv4addr = value
    host_record.view = nil
    host_record.put
  end

  def create
    Puppet.info("Infoblox::DNS::Host: Creating Host record #{name} with #{resource[:address]}")

    host_record = Infoblox::Host.new(
      connection: infoblox_client,
      name: name,
      ipv4addr: @resource[:address],
    )
    host_record.post

    @property_hash[:ensure] = :present
    end

  def destroy
    Puppet.info("Infoblox::DNS::Host: Deleting A record #{name}")

    host_record = Infoblox::Host.find(infoblox_client, name: name).first
    host_record.delete

    @property_hash[:ensure] = :absent
    end
end
