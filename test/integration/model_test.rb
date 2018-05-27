require "test_helper"

class ModelIntegrationTest < TestCase
  include Migrate

  def migration_schema
    ActiveRecord::Schema.define do
      create_table :posts, force: :cascade do |t|
        t.integer :user_id
        t.text :title
        t.text :content
        t.timestamps null: false
      end

      create_table :comments, force: :cascade do |t|
        t.integer :post_id
        t.integer :user_id
        t.string :name, null: false
        t.text :content
        t.timestamps null: false
      end

      create_table :users, force: :cascade do |t|
        t.string :name, null: false
        t.timestamps null: false
      end

      add_foreign_key :posts, :users
      add_foreign_key :comments, :posts
      add_foreign_key :comments, :users

      add_index :posts, :title, unique: true
    end
  end

  def test_postgres
    migrate_postgres do
      assert_works("pg")
    end
  end

  def test_sqlite
    migrate_sqlite do
      assert_works("sqlite")
    end
  end

  private

  def assert_works(expected_suffix)
    in_tmpdir do |tmpdir|
      FileUtils.mkdir_p("app/models")
      FileUtils.mkdir_p("config")
      File.write("app/models/application_record.rb", fixture("application_record.original"))
      File.write("app/models/post.rb", fixture("post.original"))
      File.write("app/models/comment.rb", fixture("comment.original"))
      File.write("app/models/user.rb", fixture("user.original"))
      File.write("config/who_am_i.yml", fixture("config_yml"))

      rake_run do |rake|
        load "who_am_i/tasks.rake"
        Rake::Task[:who_am_i].invoke
      end

      assert_equal(
        fixture("application_record.original"),
        File.read("app/models/application_record.rb")
      )
      assert_equal(
        fixture("post.#{expected_suffix}"),
        File.read("app/models/post.rb")
      )

      assert_equal(
        fixture("comment.#{expected_suffix}"),
        File.read("app/models/comment.rb")
      )

      assert_equal(
        fixture("user.#{expected_suffix}"),
        File.read("app/models/user.rb")
      )
    end
  end

  def fixture(fixture_name)
    @fixture ||= {}

    if @fixture.key?(fixture_name)
      return @fixture[fixture_name]
    end

    path = File.expand_path(File.join("..", "fixtures", fixture_name), __dir__)

    @fixture[fixture_name] = File.read(path)
  end
end
