module WhoAmI
  class Trees
    class TreeNode
      attr_accessor :name
      attr_accessor :children

      def initialize(name:, children: [])
        self.name = name
        self.children = children
      end
    end

    def initialize
      @trees = {}
      @tree_roots = []
    end

    def insert(name, parent_name = nil)
      if @trees.key?(name)
        raise WhoAmI::Error, "Node with name `#{name}` already exists"
      end

      if parent_name && !@trees.key?(parent_name)
        raise WhoAmI::Error, "Parent node `#{parent_name}` doesn't exist yet"
      end

      node = TreeNode.new(name: name)
      @trees[name] = node

      if parent_name.nil?
        @tree_roots.push(node)
      else
        @trees[parent_name].children.push(node)
      end
    end

    def roots
      @tree_roots.map(&:name)
    end

    def children_of(name_or_node)
      node =
        if name_or_node.is_a?(TreeNode)
          name_or_node
        else
          @trees[name_or_node]
        end

      node.children.map(&:name) + node.children.flat_map(&method(:children_of))
    end
  end
end
