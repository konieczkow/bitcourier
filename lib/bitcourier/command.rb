require 'thor'

module Bitcourier

  class Command < Thor

    desc 'node', 'Start Bitcourier node'
    method_option :port,
                  :desc    => 'port on which the Bitcourier node will listen',
                  :default => Network::Server::DEFAULT_PORT,
                  :aliases => '-p',
                  :type    => :numeric
    method_option :connections,
                  :desc    => 'number of connections to other Bitcourier nodes',
                  :default => NodeManager::DEFAULT_TARGET_CONNECTIONS,
                  :aliases => '-c',
                  :type    => :numeric

    def node
      daemon = Daemon.new :port               => options.port,
                          :target_connections => options.connections

      daemon.run
    end

  end

end
