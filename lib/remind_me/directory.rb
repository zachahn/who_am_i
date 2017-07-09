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

    def classlikes
      if @classlikes
        return @classlikes
      end

      @classlikes =
        files.flat_map do |file|
          walker = RemindMe::Walker.new
          walker.read(file)
        end
    end

    def models
      if @models
        return @models
      end

      explicit_activerecord_classlikes =
        classlikes
          .select(&:activerecord?)

      explicit_activerecords =
        explicit_activerecord_classlikes
          .map(&:relative_name)

      @models =
        classlikes.select do |classlike|
          explicit_activerecords.include?(classlike.superclass)
        end

      @models.each do |model|
        model.activerecord = true
      end

      @models += explicit_activerecord_classlikes

      @models
    end
  end
end
