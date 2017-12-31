module WhoAmI
  module Function
    class GetTables
      include ProcParty

      def call
        ActiveRecord::Base.connection.tables
      end
    end
  end
end
