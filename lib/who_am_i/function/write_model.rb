module WhoAmI
  module Function
    class WriteModel
      include ProcParty

      def call(extracted_class)
        content =
          "#{extracted_class.computed_header}" \
          "\n" \
          "#{extracted_class.computed_content}" 

        File.write(extracted_class.model_filepath, content)
      end
    end
  end
end
