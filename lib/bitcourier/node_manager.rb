module Bitcourier
  class NodeManager

    attr_reader :context

    attr_accessor :target_connections

    def initialize(context, options = {})
      @context = context
      @nodes   = []

      self.target_connections = options.fetch(:target_connections, Bitcourier::CONFIG[:default_target_connections])
    end

    def needs_nodes?
      nodes.count < target_connections
    end

    def add_socket socket, active = false
      node = Node.new context, socket

      if active
        node.set_state Node::ActiveHandshake
      else
        node.set_state Node::PassiveHandshake
      end

      nodes << node

      node.run
    end

    def to_address_array
      a = AddressArray.new

      nodes.each do |node|
        a << node.to_addr
      end

      return a
    end

    private

    attr_reader :nodes

  end
end
