module WhoAmI
  module Refinement
    module YieldSelf
      refine Object do
        if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5.0")
          def yield_self
            if block_given?
              yield(self)
            else
              enum_for(:yield_self)
            end
          end
        end
      end
    end
  end
end
