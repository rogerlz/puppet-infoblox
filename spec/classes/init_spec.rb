require 'spec_helper'

describe 'sstk_infoblox' do
  context 'compiles?' do
    it { is_expected.to compile }
  end

  context do
    it { is_expected.to contain_package('infoblox').only_with('ensure' => 'present', 'provider' => 'puppet_gem') }
  end
end
