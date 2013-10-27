require 'thor'

module Bitcourier

  class Command < Thor

    desc 'node', 'Start Bitcourier node'
    method_option :port,
                  desc:    'port on which the Bitcourier node will listen',
                  default: Network::Server::DEFAULT_PORT,
                  aliases: '-p',
                  type:    :numeric

    def node
      Daemon.new.run port: options.port
    end

  end

end
