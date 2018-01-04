module WhoAmI
  module Function
    class LoadInflections
      include ProcParty

      def call
        if File.exist?("config/initializers/inflections.rb")
          load "config/initializers/inflections.rb"
        end
      end
    end
  end
end
