module WhoAmI
  module Refinement
    module HashDig
      refine Hash do
        if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.3.0")
          def dig(head, *tail)
            if tail.empty? || !self.key?(head)
              self[head]
            else
              self[head].dig(*tail)
            end
          end
        end
      end
    end
  end
end
