require 'spec_helper'

describe Puppet::Type.type(:infoblox_dns_a) do
  it 'works with hostname and ip' do
    expect {
      Puppet::Type.type(:infoblox_dns_a).new(
        fqdn: 'hostname12',
        address: '169.254.0.1',
      )
    }.not_to raise_error
  end

  it 'does not allow blank ip' do
    expect {
      Puppet::Type.type(:infoblox_dns_a).new(
        fqdn: 'hostname12',
        address: '',
      )
    }.to raise_error
  end

  it 'accepts valid ttl' do
    expect {
      Puppet::Type.type(:infoblox_dns_a).new(
        fqdn: 'hostname12',
        ttl: '600',
        address: '169.254.0.1',
      )
    }.not_to raise_error
  end

  it 'rejects invalid ttl' do
    expect {
      Puppet::Type.type(:infoblox_dns_a).new(
        fqdn: 'hostname12',
        ttl: 'abcdef',
        address: '169.254.0.1',
      )
    }.to raise_error
  end
end
