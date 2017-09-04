module RemindMe
  class Comment
    def initialize(table_name:)
      @model_info = ModelInfo.new(table_name)
    end

    def output
      output_header + output_schema + output_footer
    end

    private

    def output_header
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: #{@model_info.table_name}\n" \
      "#\n"
    end

    def output_schema
      tt = TextTable.new(join: "    ", prefix: "#   ")

      @model_info.columns.each do |column_info|
        tt.push([
          column_info.name,
          column_info.type,
          column_info.attributes.join(", "),
        ])
      end

      tt.each.to_a.join("\n") + "\n"
    end

    def output_footer
      "#\n"
    end
  end
end
