module WhoAmI
  module Function
    class Main
      def initialize(root)
        @root = root
      end

      def call
        config = LoadConfig.new(@root).call
        tables = GetTables.new.call
        LoadInflections.new.call

        AnnotateModels.new(config[:enabled][:models], tables).call
      end
    end
  end
end
