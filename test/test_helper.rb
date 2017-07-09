$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "remind_me"

require "active_record"
require_relative "support/models/post"
require_relative "support/models/category"
require_relative "support/migrate"

require "minitest/autorun"
require "pry-byebug"
