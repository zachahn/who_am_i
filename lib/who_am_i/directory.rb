module WhoAmI
  class Directory
    include Enumerable

    def initialize(search:, connection:)
      @search_paths = [search].flatten
      @activerecord_connection = connection
    end

    def files
      @search_paths.flat_map do |path|
        glob = File.expand_path(File.join(path, "**", "*.rb"))

        Dir[glob]
      end
    end

    def tables
      @activerecord_connection.tables
    end

    def classlikes
      if @classlikes
        return @classlikes
      end

      @classlikes =
        files.flat_map do |file|
          walker = WhoAmI::Walker.new
          walker.read(file)
        end
    end

    def models
      if @models
        return @models
      end

      models = []
      non_models = classlikes.dup

      loop do
        previous_model_count = models.count

        non_models =
          non_models.reduce([]) do |memo, classlike|
            if classlike.activerecord? || child_of_model?(models, classlike)
              classlike.activerecord = true
              models.push(classlike)

              next memo
            end

            memo.push(classlike)
          end

        if previous_model_count == models.count
          break
        end
      end

      @models = models
    end

    private

    def child_of_model?(models, classlike)
      models.map(&:relative_name).include?(classlike.superclass)
    end
  end
end
