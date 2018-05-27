# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "who_am_i/version"

Gem::Specification.new do |spec|
  spec.name = "who_am_i"
  spec.version = WhoAmI::VERSION
  spec.authors = ["Zach Ahn"]
  spec.email = ["engineering@zachahn.com"]

  spec.summary = "Table schema reminders in the model"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "the_bath_of_zahn"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pg", "< 1.0.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "m", "~> 1.5"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "foreigner"
  spec.add_development_dependency "dotenv"

  spec.add_runtime_dependency "activerecord", ">= 4.0", "< 6.0"
  spec.add_runtime_dependency "parser"
  spec.add_runtime_dependency "proc_party"
end
