module WhoAmI
  module Function
    class ComputeContent
      include ProcParty

      def call(extracted_class)
        original_content = File.read(extracted_class.model_filepath)
        bare_content = RemoveAnnotation.new.call(original_content)
        extracted_class.computed_content = bare_content
      end
    end
  end
end
