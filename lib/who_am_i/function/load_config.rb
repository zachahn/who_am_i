module WhoAmI
  module Function
    class LoadConfig
      include ProcParty

      def initialize(root)
        @root = root
      end

      def call
        Config.new(loaded_configuration)
      end

      private

      def loaded_configuration
        @loaded_configuration ||=
          if File.exist?(initializer_path)
            contents = YAML.load_file(initializer_path)
            deep_symbolize_hash(contents)
          else
            warn "WhoAmI configuration not found, using default"
            {}
          end
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
