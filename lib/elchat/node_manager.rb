module Elchat
  class NodeManager
    attr_accessor :context

    def initialize context
      self.nodes   = []
      self.context = context
    end

    def needs_nodes?
      nodes.count < 1
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

    attr_accessor :nodes

  end
end
