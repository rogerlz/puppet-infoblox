require_relative '../../../puppet_x/infoblox.rb'
require 'infoblox'

module Puppet::Parser::Functions
  newfunction(:infoblox_function, :type => :rvalue) do |args|
    func_name = __method__.to_s.sub!('real_function_','')

    unless args.length == 1 then
      raise Puppet::ParseError, ("#{func_name}(): wrong number of arguments (#{args.length}; must be 1)")
    end

    fqdn = args[0]


    # TODO: implement exception with begin/rescue
    connection = PuppetX::InfobloxProvider.infoblox_client
    response = Infoblox::Arecord.find(connection, {
      name: fqdn,
    })

    response.ipv4addr

  end
end
