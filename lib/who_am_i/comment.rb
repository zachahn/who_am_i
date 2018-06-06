module WhoAmI
  class Comment
    def initialize(table_name:)
      @model_info = TableInfo.new(table_name)
    end

    def output
      output_header + output_schema + output_indices + output_foreign_keys
    end

    private

    def output_header
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: #{@model_info.table_name}\n" \
      "#\n"
    end

    def output_schema
      if @model_info.columns.none?
        return ""
      end

      tt = TextTable.new(join: "    ", prefix: "#   ")

      @model_info.columns.each do |column_info|
        tt.push([
          column_info.name,
          column_info.type,
          column_info.attributes.join(", "),
        ])
      end

      tt.to_s + "#\n"
    end

    def output_indices
      if @model_info.indices.none?
        return ""
      end

      tt = TextTable.new(join: "    ", prefix: "#   ")

      @model_info.indices.each do |index|
        description = "(#{index.columns.join(", ")})"
        if index.unique
          description += " UNIQUE"
        end
        tt.push([index.name, description])
      end

      header =
        "# Indices:\n" \
        "#\n"

      header + tt.to_s + "#\n"
    end

    def output_foreign_keys
      if @model_info.foreign_keys.empty?
        return ""
      end

      tt = TextTable.new(join: "    ", prefix: "#   ")

      @model_info.foreign_keys.each do |fk|
        tt.push(
          [
            fk.column,
            "#{fk.to_table}.#{fk.primary_key}",
            fk.name,
          ]
        )
      end

      header =
        "# Foreign keys:\n" \
        "#\n"

      header + tt.to_s + "#\n"
    end
  end
end
