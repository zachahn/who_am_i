module WhoAmI
  module Function
    class ParseModel
      include ProcParty

      def call(path)
        walker = WhoAmI::FindClasses.new
        extracted_classes = walker.read_and_call(path)

        extracted_classes.each { |klass| klass.model_filepath = path }
      end
    end
  end
end
