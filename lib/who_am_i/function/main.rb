module WhoAmI
  module Function
    class Main
      def initialize(root)
        @root = root
      end

      def call
        config = LoadConfig.new(@root).call
        SetupEnvironment.new(config, @root).call
        tables = GetTables.new.call

        AnnotateModels.new(config, tables).call
      end
    end
  end
end
