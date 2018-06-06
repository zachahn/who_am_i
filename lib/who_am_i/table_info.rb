module WhoAmI
  class TableInfo
    def initialize(table_name)
      @table_name = table_name
    end

    attr_reader :table_name

    def columns
      @columns ||=
        begin
          columns_hash =
            ActiveRecord::Base.connection.schema_cache.columns_hash(@table_name)

          columns_hash.values.map do |column|
            TableColumnInfo.new(table_name: @table_name, column: column)
          end
        end
    end

    def indices
      @indices ||= ActiveRecord::Base.connection.indexes(@table_name)
    end

    def foreign_keys
      @foreign_keys ||= ActiveRecord::Base.connection.foreign_keys(@table_name)
    end
  end
end
