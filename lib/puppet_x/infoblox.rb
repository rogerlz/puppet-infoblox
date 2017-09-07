module PuppetX
  class Infoblox < Puppet::Provider
    def self.client_config
      Puppet.initialize_settings unless Puppet[:confdir]
      path = File.join(Puppet[:confdir], 'infoblox_credentials.ini')
      File.exist?(path) ? ini_parse(File.new(path)) : nil
    end

    def self.ini_parse(file)
      current_section = {}
      map = {}
      file.rewind
      file.each_line do |line|
        line = line.split(%r{^|\s;}).first # remove comments
        section = line.match(%r{^\s*\[([^\[\]]+)\]\s*$}) unless line.nil?
        if section
          current_section = section[1]
        elsif current_section
          item = line.match(%r{^\s*(.+?)\s*=\s*(.+?)\s*$}) unless line.nil?
          if item
            map[current_section] = map[current_section] || {}
            map[current_section][item[1]] = item[2]
          end
        end
      end
      map
    end

    def self.infoblox_client
      ::Infoblox::Connection.new(username: client_config['default']['username'], password: client_config['default']['password'], host: client_config['default']['host'], ssl_opts: { verify: false })
    end

    def infoblox_client
      self.class.infoblox_client
    end
  end
end
