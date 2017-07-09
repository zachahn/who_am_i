module RemindMe
  class Directory
    include Enumerable

    def initialize(models:, connection:)
      @models_directory_paths = models
      @ar_connection = connection
    end

    def files
      @models_directory_paths.flat_map do |path|
        glob = File.expand_path(File.join(path, "**", "*.rb"))

        Dir[glob]
      end
    end

    def tables
      @ar_connection.tables
    end
  end
end
