module RemindMe
  class Comment
    def initialize(table_name:)
      @table_name = table_name
    end

    def output
      output_header + output_schema + output_footer
    end

    private

    def output_header
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: post\n" \
      "#\n"
    end

    def output_schema
      tt = TextTable.new(join: " ", prefix: "#   ")

      schema_info.each do |column_info|
        tt.push([
          column_info.name,
          column_info.sql_type_metadata.type,
        ])
      end

      tt.each.to_a.join("\n") + "\n"
    end

    def output_footer
      "#\n"
    end

    def schema_info
      @schema_info ||= Function::GetSchema.new(@table_name).call
    end
  end
end
