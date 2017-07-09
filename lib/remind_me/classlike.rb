module RemindMe
  class Classlike
    attr_accessor :name
    attr_accessor :outerclass
    attr_accessor :activerecord
    attr_accessor :superclass
    attr_accessor :table_name
    attr_accessor :filename

    def initialize(name,
      outerclass: nil,
      activerecord: false,
      superclass: nil,
      table_name: nil)
      self.name = name
      self.outerclass = outerclass
      self.activerecord = activerecord
      self.superclass = superclass
      self.table_name = table_name
    end

    def activerecord?
      @activerecord
    end

    def to_s
      if name
        "#{outerclass}::#{name}"
      else
        ""
      end
    end
  end
end
