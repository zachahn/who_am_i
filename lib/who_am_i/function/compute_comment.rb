module WhoAmI
  module Function
    class ComputeComment
      include ProcParty

      def call(extracted_class)
        commenter =
          WhoAmI::Comment.new(table_name: extracted_class.table_name)
        extracted_class.computed_header = commenter.output
      end
    end
  end
end
