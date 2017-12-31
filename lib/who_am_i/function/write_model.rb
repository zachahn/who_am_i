module WhoAmI
  module Function
    class WriteModel
      include ProcParty

      def call(gathered_data)
        content =
          "#{gathered_data.computed_header}" \
          "\n" \
          "#{gathered_data.computed_content}" 

        File.write(gathered_data.path, content)
      end
    end
  end
end
