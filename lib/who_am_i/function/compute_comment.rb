module WhoAmI
  module Function
    class ComputeComment
      include ProcParty

      def call(gathered_data)
        commenter =
          WhoAmI::Comment.new(table_name: gathered_data.table_name)
        gathered_data.computed_header = commenter.output
      end
    end
  end
end
