module WhoAmI
  module Function
    class GetTables
      include ProcParty

      def call
        if ActiveRecord::Base.connection.respond_to?(:data_sources)
          ActiveRecord::Base.connection.data_sources
        else
          ActiveRecord::Base.connection.tables
        end
      end
    end
  end
end
