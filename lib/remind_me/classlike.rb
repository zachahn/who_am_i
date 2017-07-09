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

    def full_name
      if name
        "#{outerclass.full_name}::#{name}"
      else
        ""
      end
    end

    alias_method :to_s, :full_name
  end
end
