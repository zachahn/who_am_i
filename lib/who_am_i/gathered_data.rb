module WhoAmI
  class GatheredData
    attr_accessor :path
    attr_accessor :class_name
    attr_accessor :table_name
    attr_accessor :super_class
    attr_accessor :computed_header
    attr_accessor :computed_content
    attr_writer :activerecord
    attr_writer :abstract_class
    attr_reader :skipped_because

    def initialize(initial = {})
      @skipped_because = []
      initial.each do |key, value|
        send("#{key}=", value)
      end
    end

    def skip_because(level, reason)
      if [:info, :warn].include?(level)
        @skipped_because.push([level, reason])
      end
    end

    def skip?
      @skipped_because.any?
    end

    def abstract_class?
      @abstract_class
    end
  end
end
