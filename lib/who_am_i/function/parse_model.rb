module WhoAmI
  module Function
    class ParseModel
      include ProcParty

      def call(path)
        walker = WhoAmI::Walker.new
        extracted_classes = walker.read(path)

        extracted_classes
      end
    end
  end
end
