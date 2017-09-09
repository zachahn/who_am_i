module WhoAmI
  module Function
    class RemoveAnnotation
      def call(file_contents:)
        if file_contents !~ /\A# == Schema Info/
          return file_contents
        end

        keep_the_rest = false

        kept_lines =
          file_contents.lines.keep_if do |line|
            if keep_the_rest
              next true
            elsif line[0] == "#"
              next false
            else
              keep_the_rest = true
              next false
            end
          end

        kept_lines.join("")
      end
    end
  end
end
