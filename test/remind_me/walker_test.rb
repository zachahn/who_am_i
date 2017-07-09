require "test_helper"

class WalkerTest < Minitest::Test
  def test_finds_classes
    model =
      "class Post < ActiveRecord::Base\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = RemindMe::Walker.new
    classes = walker.classes(sexp)

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
    walker = RemindMe::Walker.new
    classes = walker.classes(sexp)

    assert_includes(classes.map(&:to_s), "::Extremely")
    assert_includes(classes.map(&:to_s), "::Extremely::Very")
    assert_includes(classes.map(&:to_s), "::Extremely::Very::Cool")
    assert_includes(classes.map(&:to_s), "::Extremely::Very::Cool::Post")
    assert_includes(classes.map(&:to_s), "::Extremely::Very::Boring")
    assert_includes(classes.map(&:to_s), "::Extremely::Very::Boring::Post")
    assert_equal(6, classes.size)
  end

  def test_finds_nested_compact_classes
    model =
      "class Name::Space::Post < ActiveRecord::Base\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = RemindMe::Walker.new
    classes = walker.classes(sexp)

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
    walker = RemindMe::Walker.new
    classes = walker.classes(sexp)

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
    walker = RemindMe::Walker.new
    classes = walker.classes(sexp)

    assert_equal(%i[pages], classes.map(&:table_name))
  end

  def test_find_active_record
    model =
      "class Post < ActiveRecord::Base\n" \
      "  self.table_name = :pages\n" \
      "end\n"

    sexp = Parser::CurrentRuby.parse(model)
    walker = RemindMe::Walker.new
    classes = walker.classes(sexp)

    assert_equal([true], classes.map(&:activerecord?))
  end
end
