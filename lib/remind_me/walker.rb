module RemindMe
  class Walker < AST::Processor
    def initialize
      @current_class = Classlike.new(nil)
      @classes = [@current_class]
    end

    def read(file)
      content = File.read(file)
      sexp = Parser::CurrentRuby.parse(content)

      classes(sexp).each do |klass|
        klass.filename = file
      end
    end

    def classes(sexp)
      @current_class = Classlike.new(nil)
      @classes = [@current_class]

      process(sexp)

      @classes.reject { |klass| klass.name.nil? }
    end

    def on_class(node)
      class_node, subclass_node, _body_node = *node

      class_name = resolve_class_name(class_node)

      @current_class = Classlike.new(class_name, outerclass: @current_class)
      @classes.push(@current_class)

      if subclass_node == explicit_activerecord_base
        @current_class.activerecord = true
      end

      process_children(node)

      @current_class = @current_class.outerclass
    end

    alias on_module on_class

    def on_send(node)
      receiver, method_name, table_name_node = *node

      if receiver == s(:self) && method_name == :table_name=
        table_name = table_name_node.children.last
        @current_class.table_name = table_name
      end
    end

    def handler_missing(node)
      process_children(node)
    end

    # ignore instance method definitions
    # classes cannot be defined from within a method
    def on_def(_)
    end

    # ignore class method definitions
    # classes cannot be defined from within a method
    def on_defs(_)
    end

    private

    def resolve_class_name(node)
      outer, name = *node

      if outer.nil?
        name
      else
        "#{resolve_class_name(outer)}::#{name}"
      end
    end

    def process_children(node)
      node.children.each do |child|
        if child.is_a?(AST::Node)
          process(child)
        end
      end

      node
    end

    def s(type, *children)
      AST::Node.new(type, children)
    end

    def explicit_activerecord_base
      s(:const,
        s(:const, nil, :ActiveRecord), :Base)
    end
  end
end
