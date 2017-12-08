require_relative '../../../puppet_x/infoblox.rb'

Puppet::Type.type(:infoblox_dns_cname).provide(:infoblox_dns_cname, parent: PuppetX::Infoblox) do
  confine feature: :infoblox

  mk_resource_methods

  def self.instances
    response = Infoblox::Cname.all(infoblox_client, _max_results: 10_000)
    response.map do |record|
      new(name: record.name,
          canonical: record.canonical,
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
    Puppet.info("Infoblox::DNS::CNAME: Checking if CNAME record #{name} exists")
    @property_hash[:ensure] == :present
  end

  def canonical=(value)
    Puppet.info("Infoblox::DNS::CNAME: Updating CNAME record #{name} with canonical: #{value}")

    cname_record = Infoblox::Cname.find(infoblox_client, name: name).first
    cname_record.canonical = value
    cname_record.view = nil
    cname_record.put
  end

  def create
    Puppet.info("Infoblox::DNS::CNAME: Creating CNAME record #{name} with #{resource[:canonical]}")

    cname_record = Infoblox::Cname.new(
      connection: infoblox_client,
      name: name,
      canonical: @resource[:canonical],
    )
    cname_record.post

    @property_hash[:ensure] = :present
  end

  def destroy
    Puppet.info("Infoblox::DNS::CNAME: Deleting CNAME record #{name}")

    cname_record = Infoblox::Cname.find(infoblox_client, name: name).first
    cname_record.delete

    @property_hash[:ensure] = :absent
  end
end
