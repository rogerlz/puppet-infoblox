require_relative '../../../puppet_x/infoblox.rb'

Puppet::Type.type(:infoblox_dns_a).provide(:infoblox_dns_a, parent: PuppetX::Infoblox) do
  confine feature: :infoblox

  mk_resource_methods

  def self.instances
    @response = Infoblox::Ptr.all(infoblox_client, _max_results: 9000)
    @response.map do |record|
      new(name: record.name,
          ptrdname: record.ptrdname,
          ensure: :present)
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource == resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def exists?
    Puppet.info("Infoblox::DNS::PTR: Checking if PTR record #{name} exists")
    @property_hash[:ensure] == :present
  end

  def address=(value)
    Puppet.info("Infoblox::DNS::PTR: Updating PTR record #{name} with address: #{value}")

    ptr_record = Infoblox::Ptr.find(infoblox_client, name: name).first
    ptr_record.ipv4addr = value
    ptr_record.view = nil
    ptr_record.put
  end

  def ptrdname=(value)
    Puppet.info("Infoblox::DNS::PTR: Updating A record #{name} with PTRDName: #{value}")

    ptr_record = Infoblox::PTR.find(infoblox_client, name: name).first
    ptr_record.ptrdname = value
    ptr_record.view = nil
    ptr_record.put
  end

  def create
    Puppet.info("Infoblox::DNS::PTR: Creating PTR record #{name} with #{resource[:address]}")

    ptr_record = Infoblox::PTR.new(
      connection: infoblox_client,
      name: name,
      ipv4addr: @resource[:address],
      ptrdname: @resource[:ptrdname],
    )
    ptr_record.post

    @property_hash[:ensure] = :present
  end

  def destroy
    Puppet.info("Infoblox::DNS::PTR: Deleting A record #{name}")

    ptr_record = Infoblox::PTR.find(infoblox_client, name: name).first
    ptr_record.delete

    @property_hash[:ensure] = :absent
  end
end
