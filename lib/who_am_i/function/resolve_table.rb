module WhoAmI
  module Function
    class ResolveTable
      include ProcParty

      def initialize(known_tables)
        @known_tables = known_tables
      end

      def call(extracted_class)
        set_table_name_for(extracted_class)
      end

      private

      def set_table_name_for(extracted_class)
        if extracted_class.abstract_class?
          return
        end

        if extracted_class.table_name
          return
        end

        if extracted_class.resolved_superclass
          if !extracted_class.resolved_superclass.abstract_class?
            set_table_name_for(extracted_class.resolved_superclass)

            extracted_class.table_name =
              extracted_class.resolved_superclass.table_name

            return
          end
        end

        extracted_class.table_name =
          guess_table_from(extracted_class.class_name)

        if extracted_class.table_name.nil?
          extracted_class.skip("no table could be determined")
        end
      end

      def guess_table_from(class_name)
        loop do
          guess =
            class_name
              .underscore
              .pluralize
              .sub(%r{\A/}, "")
              .sub(%r{/}, "_")

          if @known_tables.include?(guess)
            break guess
          end

          if class_name !~ /::/
            break
          end

          class_name = class_name.split("::", 2).last
        end
      end
    end
  end
end
