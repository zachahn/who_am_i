require "test_helper"

class TreesTest < TestCase
  def setup
    @trees = WhoAmI::Trees.new

    @trees.insert("::ActiveRecord::Base")
    @trees.insert("::ApplicationRecord", "::ActiveRecord::Base")
    @trees.insert("::Book", "::ApplicationRecord")
    @trees.insert("::Chapter", "::ApplicationRecord")
    @trees.insert("::Author", "::ActiveRecord::Base")
    @trees.insert("::SomeObject")
    @trees.insert("::SomeOtherObject", "::SomeObject")
    @trees.insert("::Idk")
  end

  def test_roots
    assert_equal(
      ["::ActiveRecord::Base", "::Idk", "::SomeObject"],
      @trees.roots.sort
    )
  end

  def test_children_of
    assert_equal(
      ["::ApplicationRecord", "::Author", "::Book", "::Chapter"],
      @trees.children_of("::ActiveRecord::Base").sort
    )

    assert_equal(
      [],
      @trees.children_of("::Idk")
    )

    assert_equal(
      ["::SomeOtherObject"],
      @trees.children_of("::SomeObject")
    )
  end
end
