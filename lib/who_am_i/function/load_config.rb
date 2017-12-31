module WhoAmI
  module Function
    class LoadConfig
      include ProcParty

      def initialize(root)
        @root = root
      end

      def call
        hash = YAML.load_file(config_path)
        deep_symbolize_hash(hash)
      end

      private

      def config_path
        @config_path ||=
          if File.exist?(dotfile_path)
            dotfile_path
          elsif File.exist?(initializer_path)
            initializer_path
          else
            raise WhoAmI::Error, "Configuration not found"
          end
      end

      def dotfile_path
        File.join(@root, ".who_am_i.yml")
      end

      def initializer_path
        File.join(@root, "config", "initializers", "who_am_i.yml")
      end

      def deep_symbolize_hash(obj)
        if obj.is_a?(Hash)
          obj.map { |k, v| [k.to_sym, deep_symbolize_hash(v)] }.to_h
        else
          obj
        end
      end
    end
  end
end
