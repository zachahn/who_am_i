module WhoAmI
  class ColumnInfo
    def initialize(model_class:, column:)
      @model_class = model_class
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
      case @model_class.primary_key
      when Array
        @model_class.primary_key.include?(name)
      when String
        @model_class.primary_key == name
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
