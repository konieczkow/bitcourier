module Bitcourier
  class NodeManager
    DEFAULT_MINIMUM_NODES = 3

    attr_reader :context
    attr_accessor :minimum_nodes

    def initialize(context, options = {})
      @nodes   = []
      @context = context

      self.minimum_nodes = options.fetch(:minimum_nodes, DEFAULT_MINIMUM_NODES)
    end

    def needs_nodes?
      nodes.count < minimum_nodes
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

    private

    attr_reader :nodes

  end
end
