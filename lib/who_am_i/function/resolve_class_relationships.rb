module WhoAmI
  module Function
    class ResolveClassRelationships
      include ProcParty

      def call(extracted_classes)
        object_space =
          extracted_classes
            .map(&method(:self_and_outer_class))
            .flatten
            .compact
            .uniq
            .map { |x| [x.full_name, x] }
            .to_h

        object_space[""] ||= ExtractedClass.new(nil)

        object_space["::ActiveRecord::Base"] =
          ExtractedClass.new(
            "ActiveRecord::Base",
            outerclass: object_space[""]
          )

        object_space.each do |full_name, extracted_class|
          possible_namespace_levels = full_name.split("::")[1..-2] || []

          if extracted_class.superclass == "" || extracted_class.superclass == nil
            next
          end

          (possible_namespace_levels.size + 1).times do
            class_uri_parts =
              possible_namespace_levels + [extracted_class.superclass]

            class_uri = "::#{class_uri_parts.join("::")}"

            if object_space[class_uri]
              extracted_class.resolved_superclass = object_space[class_uri]
              break
            end

            possible_namespace_levels.pop
          end
        end

        object_space
      end

      private

      def self_and_outer_class(extracted_class)
        if extracted_class.nil?
          return nil
        end

        [
          extracted_class,
          self_and_outer_class(extracted_class.outerclass)
        ]
      end
    end
  end
end
