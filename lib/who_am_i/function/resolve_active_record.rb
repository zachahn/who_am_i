module WhoAmI
  module Function
    class ResolveActiveRecord
      include ProcParty

      def call(object_space)
        tree = {}
        object_space.each do |_class_name, extracted_class|
          superclass = extracted_class.resolved_superclass

          tree[superclass] ||= Set.new
          tree[superclass].add(extracted_class)
        end

        activerecord_family =
          gather_family(object_space["::ActiveRecord::Base"], tree)

        activerecord_family.each do |individual|
          individual.activerecord = true
        end

        object_space.values - [object_space[""], object_space["::ActiveRecord::Base"]]
      end

      private

      def gather_family(node, tree)
        gather_family_helper(node, tree).flatten
      end

      def gather_family_helper(node, tree)
        if tree[node].nil?
          return node
        end

        [node] + tree[node].map { |child| gather_family_helper(child, tree) }
      end
    end
  end
end
