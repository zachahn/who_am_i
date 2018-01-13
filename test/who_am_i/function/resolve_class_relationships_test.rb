require "test_helper"

class FunctionResolveClassRelationshipsTest < TestCase
  def test_intermediate_case
    input =
      "class ApplicationRecord < ActiveRecord::Base\n" \
      "end\n" \
      "module Post\n" \
      "  class Abstract < ApplicationRecord\n" \
      "    self.table_name = :posts\n" \
      "  end\n" \
      "  class Text < Abstract; end\n" \
      "  class Photo < Abstract; end\n" \
      "  class Quote < Abstract; end\n" \
      "  class Link < Abstract; end\n" \
      "  class Chat < Abstract; end\n" \
      "  class Audio < Abstract; end\n" \
      "end\n" \
      "class Post::Video < Abstract; end\n"

    sexp = Parser::CurrentRuby.parse(input)
    walker = WhoAmI::FindClasses.new
    classes = walker.call(sexp)

    resolver = WhoAmI::Function::ResolveClassRelationships.new
    object_space = resolver.call(classes)

    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Text"].resolved_superclass)
    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Photo"].resolved_superclass)
    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Quote"].resolved_superclass)
    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Link"].resolved_superclass)
    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Chat"].resolved_superclass)
    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Audio"].resolved_superclass)
    assert_equal(object_space["::Post::Abstract"], object_space["::Post::Video"].resolved_superclass)

    assert_equal(object_space["::ApplicationRecord"], object_space["::Post::Abstract"].resolved_superclass)

    assert_equal(object_space["::ActiveRecord::Base"], object_space["::ApplicationRecord"].resolved_superclass)

    assert_nil(object_space["::ActiveRecord::Base"].resolved_superclass)
    assert_nil(object_space["::Post"].resolved_superclass)
  end
end
