module WhoAmI
  class TableColumnInfo
    def initialize(basic_model_class:, column:)
      @basic_model_class = basic_model_class
      @column = column
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
      case @basic_model_class.primary_key
      when Array
        @basic_model_class.primary_key.include?(name)
      when String
        @basic_model_class.primary_key == name
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
