require_relative '../../../puppet_x/infoblox.rb'

Puppet::Type.type(:infoblox_dns_host).provide(:infoblox_dns_host, parent: PuppetX::Infoblox) do
  confine feature: :infoblox

  def host_record_lookup
    Infoblox::Host.find(infoblox_client, _max_results: 1000, name: resource[:name]).first
  end

  def exists?
    Puppet.info("Infoblox::DNS::Host: Checking if Host record #{name} exists")
    host_record_lookup
  end

  def address
    Puppet.info("Infoblox::DNS:Host: Checking Host record #{name} for address: resource[:address]")

    host_record = Infoblox::Host.find(infoblox_client, name: resource[:name]).first
    host_array = []
    host_record.ipv4addrs.each do |ipaddr|
      host_array << ipaddr.ipv4addr
    end
    return unless host_array.sort == resource[:address].sort
    resource[:address]
  end

  def address=(value)
    Puppet.info("Infoblox::DNS::Host: Recreating Host record #{name} with address(es): #{value}")

    host_record = Infoblox::Host.find(infoblox_client, name: name).first
    host_record.delete
    create
  end

  def create
    Puppet.info("Infoblox::DNS::Host: Creating Host record #{name} with #{resource[:address]}")
    address_array = []
    resource[:address].each do |ipaddr|
      address_array << { ipv4addr: ipaddr }
    end
    host_record = Infoblox::Host.new(
      connection: infoblox_client,
      name: name,
      ipv4addrs: address_array,
    )
    host_record.post
  end

  def destroy
    Puppet.info("Infoblox::DNS::Host: Deleting Host record #{name}")

    host_record = Infoblox::Host.find(infoblox_client, name: resource[:name]).first
    host_record.delete
  end
end
