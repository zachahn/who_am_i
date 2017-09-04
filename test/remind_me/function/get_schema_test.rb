require "test_helper"

class FunctionGetSchemaTest < TestCase
  include Migrate

  def setup
    migrate!
  end

  def test_call
    getter = RemindMe::Function::GetSchema.new("post")
    result = getter.call

    assert_kind_of(Array, result)
  end
end
