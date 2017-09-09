module WhoAmI
  class TextTable
    include Enumerable

    def initialize(join:, prefix: "", suffix: "")
      @join = join
      @prefix = prefix
      @suffix = suffix
      @rows = []
      @column_lengths = []
    end

    def push(row)
      @rows.push(row)

      row.each.with_index do |field, index|
        @column_lengths[index] =
          if @column_lengths[index].nil?
            field.length
          else
            [@column_lengths[index], field.length].max
          end
      end

      true
    end

    def each
      if !block_given?
        return enum_for(:each)
      end

      @rows.each do |row|
        output_fields =
          row.map.with_index do |field, index|
            field.to_s.ljust(@column_lengths[index], " ")
          end

        output_row = @prefix + output_fields.join(@join) + @suffix

        yield output_row
      end
    end

    def to_s
      map(&:rstrip).join("\n") + "\n"
    end
  end
end
