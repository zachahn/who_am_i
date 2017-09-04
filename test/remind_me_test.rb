require "test_helper"

class RemindMeTest < TestCase
  include Migrate

  def test_it_prints_schema_for_one_table
    migrate!

    expected =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: post\n" \
      "#\n" \
      "#   id          integer \n" \
      "#   category_id integer \n" \
      "#   author      string  \n" \
      "#   content     text    \n" \
      "#   created_at  datetime\n" \
      "#   updated_at  datetime\n" \
      "#\n"

    engine = RemindMe::Comment.new(table_name: "post")
    result = engine.output

    assert_equal(expected, result)
  end
end
