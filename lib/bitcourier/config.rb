require 'yaml'

module Bitcourier

  class Config

    CONFIG_FILE_PATH = "~/.bitcourier/config.yml"

    DEFAULT_CONFIG = {
        peer_connection_retry_delay: 5,
        next_peer_delay: 5,
        connect_timeout: 5,
        default_target_connections: 3,
        default_port: 6081,
        peer_list_path: './tmp/peer_list.txt',
        peer_seed: '146.185.167.10'
    }

    VALID_CONFIG_KEYS = DEFAULT_CONFIG.keys

    attr_reader :config

    def initialize
      @config = DEFAULT_CONFIG
      config_from_file = load_config_from_file
      configure config_from_file if config_from_file
    end

    private
    def load_config_from_file
      begin
        YAML::load(IO.read(File.expand_path(CONFIG_FILE_PATH)))
      rescue Errno::ENOENT
        puts("YAML configuration file couldn't be found (#{CONFIG_FILE_PATH}). Using defaults."); return
      rescue Psych::SyntaxError
        puts("YAML configuration file contains invalid syntax. Using defaults."); return
      end
    end

    def configure(opts = {})
      opts.each do |key, value|
        @config[key.to_sym] = value if VALID_CONFIG_KEYS.include? key.to_sym
      end
    end

  end

end