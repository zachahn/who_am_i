module WhoAmI
  module Function
    class LoadInitializers
      include ProcParty

      def initialize(config, root)
        @config = config
        @root = root
      end

      def call
        paths = @config.load_environment_manual_initializers

        paths.each do |path|
          abspath = File.expand_path(path, @root)

          if File.exist?(abspath)
            load abspath
          end
        end
      end
    end
  end
end
