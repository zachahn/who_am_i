module WhoAmI
  module Function
    class ComputeContent
      include ProcParty

      PATTERN = %r{\A(?:(?:^#.*?$)\n)*\n*(.*)}m

      def call(extracted_class)
        original_content = File.read(extracted_class.model_filepath)
        content = PATTERN.match(original_content)
        extracted_class.computed_content = content
      end
    end
  end
end
