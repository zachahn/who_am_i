require "test_helper"

class BlogIntegrationTest < TestCase
  include Migrate

  def migration_schema
    ActiveRecord::Schema.define do
      create_table :posts, force: true do |t|
        t.text :content
        t.timestamps null: false
      end

      create_table :comments, force: true do |t|
        t.integer :post_id
        t.string :name, null: false
        t.text :content
        t.timestamps null: false
      end

      add_foreign_key :comments, :posts
    end
  end

  def application_record_class
    @application_record_class ||=
      "class ApplicationRecord < ActiveRecord::Base\n" \
      "  self.abstract_class = true\n" \
      "end\n"
  end

  def post_class
    @post_class ||=
      "class Post < ApplicationRecord\n" \
      "  has_many :comments\n" \
      "end\n"
  end

  def comment_class
    @comment_class ||=
      "class Comment < ActiveRecord::Base\n" \
      "  belongs_to :post\n" \
      "end\n"
  end

  def config_yml
    @config_yml ||=
      "---\n" \
      "enabled:\n" \
      "  models:\n" \
      "    paths:\n" \
      "      - app/models\n"
  end

  def test_
    migrate!

    in_tmpdir do |tmpdir|
      FileUtils.mkdir_p("app/models")
      FileUtils.mkdir_p("config/initializers")
      File.write("app/models/application_record.rb", application_record_class)
      File.write("app/models/post.rb", post_class)
      File.write("app/models/comment.rb", comment_class)
      File.write("config/initializers/who_am_i.yml", config_yml)

      rake_run do |rake|
        load "who_am_i/rake.rb"
        Rake::Task[:who_am_i].invoke
      end

      assert_match(/\A#/, File.read("app/models/post.rb"))
    end
  end
end
