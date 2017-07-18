$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "remind_me"

require "active_record"
require_relative "support/migrate"

require "minitest/autorun"
require "pry-byebug"

if defined?(MiniTest::Unit::TestCase)
  MiniTest::Test = MiniTest::Unit::TestCase
end

class TestCase < Minitest::Test
end
