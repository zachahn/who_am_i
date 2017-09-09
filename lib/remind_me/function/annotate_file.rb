module RemindMe
  module Function
    class AnnotateFile
      def call(table_name:, file_contents:)
        new_comment = Comment.new(table_name: table_name).output
      end
    end
  end
end
