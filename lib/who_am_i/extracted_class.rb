module WhoAmI
  class ExtractedClass
    attr_writer :name
    attr_accessor :outerclass
    attr_accessor :activerecord
    attr_writer :claimed_superclass
    attr_accessor :table_name
    attr_accessor :model_filepath
    attr_accessor :abstract_class
    attr_accessor :resolved_superclass

    def initialize(name,
      outerclass: nil,
      activerecord: false,
      claimed_superclass: nil,
      table_name: nil,
      abstract_class: nil)
      self.name = name
      self.outerclass = outerclass
      self.activerecord = activerecord
      self.claimed_superclass = claimed_superclass
      self.table_name = table_name
      self.abstract_class = abstract_class
    end

    def activerecord?
      !!@activerecord
    end

    def abstract_class?
      !!@abstract_class
    end

    def claimed_superclass
      @claimed_superclass.to_s
    end

    def full_name
      if @name
        "#{outerclass.full_name}::#{@name}"
      else
        ""
      end
    end

    alias_method :to_s, :full_name
  end
end
