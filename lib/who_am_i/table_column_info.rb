module WhoAmI
  class TableColumnInfo
    def initialize(table_name:, column:)
      @column = column
      @primary_key = ActiveRecord::Base.get_primary_key(@table_name)
    end

    def name
      @column.name
    end

    def type
      @column.type.to_s
    end

    def attributes
      @attributes ||=
        begin
          attrs = [
            not_null? && "not null",
            primary_key? && "primary key",
            default,
          ]

          attrs.select { |attr| attr }
        end
    end

    def primary_key?
      case @primary_key
      when Array
        @primary_key.include?(name)
      when String
        @primary_key == name
      else
        false
      end
    end

    def not_null?
      !@column.null
    end

    def default
      if @column.default
        "default (#{@column.default})"
      end
    end
  end
end
