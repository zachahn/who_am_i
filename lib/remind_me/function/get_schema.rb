module RemindMe
  class Function
    class GetSchema
      def initialize(table_name)
        @table_name = table_name
      end

      def call
        table = @table_name
        model_class = Class.new(ActiveRecord::Base) { self.table_name = table }

        model_class.columns
      end
    end
  end
end
