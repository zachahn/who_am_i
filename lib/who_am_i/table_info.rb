module WhoAmI
  class TableInfo
    def initialize(table_name)
      @table_name = table_name
    end

    attr_reader :table_name

    def columns
      @columns ||=
        basic_model_class.columns.map do |column|
          TableColumnInfo.new(basic_model_class: basic_model_class, column: column)
        end
    end

    def indices
      @indices ||=
        basic_model_class.connection.indexes(@table_name)
    end

    private

    def basic_model_class
      @basic_model_class ||=
        begin
          table = @table_name
          Class.new(ActiveRecord::Base) { self.table_name = table }
        end
    end
  end
end
