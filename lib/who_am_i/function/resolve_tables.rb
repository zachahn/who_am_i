module WhoAmI
  module Function
    class ResolveTables
      include ProcParty

      def call(extracted_classes)
        extracted_classes.each do |extracted_class|
          if !extracted_class.table_name.nil?
            next
          end

          extracted_class.table_name =
            if Kernel.const_defined?(extracted_class.class_name)
              Kernel.const_get(extracted_class.class_name).table_name
            else
              extracted_class.class_name
                .underscore
                .pluralize
                .sub(%r{\A/}, "")
            end
        end
      end
    end
  end
end
