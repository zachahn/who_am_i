module WhoAmI
  module Function
    class ResolveActiveRecord
      class Graph < Hash
        include TSort

        alias tsort_each_node each_key

        def tsort_each_child(node, &block)
          fetch(node).each(&block)
        end
      end

      include ProcParty

      def call(classes_info)
        name_to_class_info = {}
        dependency_graph = Graph.new

        classes_info.each do |class_info|
          name = class_info.to_s
          dependency_graph[name] ||= Set.new

          if name_to_class_info[name].nil?
            name_to_class_info[name] = class_info
          end

          if class_info.superclass
            superclass_name = "::#{class_info.superclass}"

            if name_to_class_info[superclass_name].nil?
              name_to_class_info[superclass_name] = nil
            end

            dependency_graph[name] << superclass_name
            dependency_graph[superclass_name] ||= Set.new
          end
        end

        trees = Trees.new

        # pp name_to_class_info
        dependency_graph.tsort.each do |class_name|
          class_info = name_to_class_info[class_name]
          superclass_name =
            if class_info && class_info.superclass
              "::#{class_info.superclass}"
            else
              nil
            end

          trees.insert(class_name, superclass_name)
        end

        trees.children_of("::ActiveRecord::Base").map do |class_name|
          class_info = name_to_class_info[class_name]
          class_info.activerecord = true

          class_info
        end
      end
    end
  end
end
