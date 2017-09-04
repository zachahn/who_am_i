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
      "#   id             integer     not null, primary key   \n" \
      "#   category_id    integer                             \n" \
      "#   author         string      not null, default (Mr F)\n" \
      "#   content        text                                \n" \
      "#   created_at     datetime    not null                \n" \
      "#   updated_at     datetime    not null                \n" \
      "#\n"

    engine = RemindMe::Comment.new(table_name: "post")
    result = engine.output

    assert_equal(expected, result)
  end
end
