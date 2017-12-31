module WhoAmI
  module Function
    class ResolveTables
      include ProcParty

      def call(gathered_datas)
        gathered_datas.each do |gathered_data|
          if !gathered_data.table_name.nil?
            next
          end

          gathered_data.table_name =
            if Kernel.const_defined?(gathered_data.class_name)
              Kernel.const_get(gathered_data.class_name).table_name
            else
              gathered_data.class_name
                .underscore
                .pluralize
                .sub(%r{\A/}, "")
            end
        end
      end
    end
  end
end
