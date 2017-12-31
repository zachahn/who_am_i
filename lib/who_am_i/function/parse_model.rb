module WhoAmI
  module Function
    class ParseModel
      include ProcParty

      def call(path)
        walker = WhoAmI::Walker.new
        classes_info = walker.read(path)

        classes_info
      end
    end
  end
end
