require "test_helper"

class FindClassesTest < TestCase
  def test_finds_classes
    model =
      "class Post < ActiveRecord::Base\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_equal(["::Post"], classes.map(&:to_s))
  end

  def test_finds_nested_expanded_classes
    model =
      "class Extremely\n" \
      "  module Very\n" \
      "    class Cool < Extremely\n" \
      "      class Post < ActiveRecord::Base\n" \
      "      end\n" \
      "    end\n" \
      "\n" \
      "    class Boring < Extremely\n" \
      "      class Post\n" \
      "      end\n" \
      "    end\n" \
      "  end\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_equal(
      [
        "::Extremely",
        "::Extremely::Very",
        "::Extremely::Very::Boring",
        "::Extremely::Very::Boring::Post",
        "::Extremely::Very::Cool",
        "::Extremely::Very::Cool::Post",
      ],
      classes.map(&:to_s).sort
    )
  end

  def test_finds_nested_compact_classes
    model =
      "class Name::Space::Post < ActiveRecord::Base\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_includes(classes.map(&:to_s), "::Name::Space::Post")
    assert_equal(1, classes.size)
  end

  def test_finds_nested_nested_classes
    model =
      "module Such::A::Cool\n" \
      "  class Namespace\n" \
      "    class And\n" \
      "      class Post < ActiveRecord::Base\n" \
      "      end\n" \
      "    end\n" \
      "  end\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_includes(classes.map(&:to_s), "::Such::A::Cool")
    assert_includes(classes.map(&:to_s), "::Such::A::Cool::Namespace")
    assert_includes(classes.map(&:to_s), "::Such::A::Cool::Namespace::And")
    assert_includes(classes.map(&:to_s), \
      "::Such::A::Cool::Namespace::And::Post")
    assert_equal(4, classes.size)
  end

  def test_table_name
    model =
      "class Post < ActiveRecord::Base\n" \
      "  self.table_name = :pages\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_equal(%i[pages], classes.map(&:table_name))
  end

  def test_abstract_class
    model =
      "class Post < ActiveRecord::Base\n" \
      "  self.abstract_class = true\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_equal([true], classes.map(&:abstract_class?))
  end

  def test_get_full_subclass
    model =
      "class Post < Active::Record::Base\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    klass = walker.call(sexp).first

    assert_equal("Active::Record::Base", klass.claimed_superclass)
  end

  def test_superclass_of_namespace
    model =
      "module Post\n" \
      "  class Text; end\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    extracted_classes = walker.call(sexp).map { |x| [x.class_name, x] }.to_h

    subject = extracted_classes["::Post"]

    assert_equal("", subject.claimed_superclass)
  end

  def test_finds_multiple_sequential_classes
    model =
      "class SomeError < StandardError\n" \
      "end\n" \
      "\n" \
      "class Post < ActiveRecord::Base\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    assert_equal(
      [
        "::Post",
        "::SomeError",
      ],
      classes.map(&:to_s).sort
    )
  end
end
