module WhoAmI
  module Function
    class SetupEnvironment
      include ProcParty

      def initialize(config, root)
        @config = config
        @root = root
      end

      def call
        approach = @config.load_environment_approach

        if approach == :rake
          rake(@config.load_environment_rake_task)
        elsif approach == :manual
          ConnectToDatabase.new(@config, @root).call
          LoadInitializers.new(@config, @root).call
        end
      end

      private

      def rake(task_name)
        Rake::Task[task_name].invoke
      end
    end
  end
end
