require "test_helper"

class FunctionRemoveAnnotationTest < TestCase
  def test_removes_schema_info
    contents =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: thingamajigs\n" \
      "#\n" \
      "#   id      integer    not null, primary key\n" \
      "#   name    string\n" \
      "#\n" \
      "\n" \
      "class Thingamajig < ActiveRecord::Base\n" \
      "end\n"

    expected =
      "class Thingamajig < ActiveRecord::Base\n" \
      "end\n"

    result = WhoAmI::Function::RemoveAnnotation.new.call(file_contents: contents)
    assert_equal(expected, result)
  end

  def test_doesnt_remove_random_comment
    contents =
      "# Man, this is such a bad name for a model\n" \
      "\n" \
      "class Thingamajig < ActiveRecord::Base\n" \
      "end\n"

    expected =
      "# Man, this is such a bad name for a model\n" \
      "\n" \
      "class Thingamajig < ActiveRecord::Base\n" \
      "end\n"

    result = WhoAmI::Function::RemoveAnnotation.new.call(file_contents: contents)
    assert_equal(expected, result)
  end

  def test_only_removes_first_comment_block_of_annotation
    contents =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: thingamajigs\n" \
      "#\n" \
      "#   id      integer    not null, primary key\n" \
      "#   name    string\n" \
      "#\n" \
      "\n" \
      "# Man, this is such a bad name for a model\n" \
      "class Thingamajig < ActiveRecord::Base\n" \
      "end\n"

    expected =
      "# Man, this is such a bad name for a model\n" \
      "class Thingamajig < ActiveRecord::Base\n" \
      "end\n"

    result = WhoAmI::Function::RemoveAnnotation.new.call(file_contents: contents)
    assert_equal(expected, result)
  end
end
