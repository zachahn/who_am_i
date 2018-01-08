module WhoAmI
  module Function
    class ConnectToDatabase
      include ProcParty

      def initialize(config, root)
        @config = config
        @root = root
      end

      def call
        if ActiveRecord::Base.connected?
          return
        end

        require "erb"

        config_path = config.load_environment_manual_database

        db_config = YAML.load(ERB.new(File.read(config_path)).result)

        ActiveRecord::Base.establish_connection(db_config["development"])
      end
    end
  end
end
