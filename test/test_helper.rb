$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "who_am_i"
require "who_am_i/rake"

require "fileutils"
require "rake"
require "active_record"
require "active_support/all"
require_relative "support/migrate"
require_relative "support/misc_methods"

require "minitest/autorun"
require "pry-byebug"

if !defined?(Minitest::Test)
  MiniTest::Test = MiniTest::Unit::TestCase
end

if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new("4.2")
  require "foreigner"
end

class TestCase < Minitest::Test
  include MiscMethods
end
