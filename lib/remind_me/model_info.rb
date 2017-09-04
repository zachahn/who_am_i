module RemindMe
  class ModelInfo
    def initialize(table_name)
      @table_name = table_name
    end

    attr_reader :table_name

    def model_class
      @model_class ||=
        begin
          table = @table_name
          Class.new(ActiveRecord::Base) { self.table_name = table }
        end
    end

    def columns
      @columns ||=
        model_class.columns.map do |column|
          ColumnInfo.new(model_class: model_class, column: column)
        end
    end
  end
end
