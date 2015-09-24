require "docker/env/version"
require "docker"

module Docker
  module Env

    def self.set_env

      Docker::Container.all.find_all do |c|
        puts c.to_json
        c.info['Names'].map { |n| n.split('/').last.upcase }.uniq.each do |service_name|
          c.info['Ports'].each do |port_info|
            puts port_info.to_json
            puts service_name
            if public_port = port_info['PublicPort']
              private_port = port_info['PrivatePort']
              port_type = port_info['Type']
              addr = "#{service_name}_PORT_#{private_port}_#{port_type.upcase}_ADDR"
              port = "#{service_name}_PORT_#{private_port}_#{port_type.upcase}_PORT"
              ENV[addr] = 'localhost'
              ENV[port] = "#{public_port}"
            end
          end
        end
      end

    # just log and do nothing if no docker available (like when we are inside a docker container)
    rescue Excon::Errors::SocketError => e
      Rails.logger.info e
    end

    class Railtie < ::Rails::Railtie
      config.before_initialize do
        Docker::Env::set_env()
      end
    end

  end
end
