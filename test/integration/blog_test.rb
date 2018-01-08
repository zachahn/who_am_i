require "test_helper"

class BlogIntegrationTest < TestCase
  include Migrate

  def migration_schema
    ActiveRecord::Schema.define do
      create_table :posts, force: true do |t|
        t.integer :user_id
        t.text :content
        t.timestamps null: false
      end

      create_table :comments, force: true do |t|
        t.integer :post_id
        t.integer :user_id
        t.string :name, null: false
        t.text :content
        t.timestamps null: false
      end

      create_table :users, force: true do |t|
        t.string :name, null: false
        t.timestamps null: false
      end

      add_foreign_key :posts, :users
      add_foreign_key :comments, :posts
      add_foreign_key :comments, :users
    end
  end

  def original_application_record_content
    @original_application_record_content ||=
      "class ApplicationRecord < ActiveRecord::Base\n" \
      "  self.abstract_class = true\n" \
      "end\n"
  end

  def original_post_content
    @original_post_content ||=
      "class Post < ApplicationRecord\n" \
      "  has_many :comments\n" \
      "end\n"
  end

  def original_comment_content
    @original_comment_content ||=
      "# This is my favorite class!\n" \
      "\n" \
      "class Comment < ActiveRecord::Base\n" \
      "  belongs_to :post\n" \
      "end\n"
  end

  def original_user_content
    @original_user_content ||=
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: users\n" \
      "#\n" \
      "#   id            integer     not null, primary key\n" \
      "#   name          string      not null\n" \
      "#   created_at    datetime    not null\n" \
      "#   updated_at    datetime    not null\n" \
      "#\n" \
      "\n" \
      "class User < ActiveRecord::Base\n" \
      "  has_many :posts\n" \
      "end\n"
  end

  def config_yml
    @config_yml ||=
      "---\n" \
      "autorun:\n" \
      "  enabled: false\n" \
      "environment:\n" \
      "  approach: manual\n" \
      "enabled:\n" \
      "  models:\n" \
      "    paths:\n" \
      "      - app/models/**/*.rb\n"
  end

  def test_from_scratch
    migrate!

    in_tmpdir do |tmpdir|
      FileUtils.mkdir_p("app/models")
      FileUtils.mkdir_p("config")
      File.write("app/models/application_record.rb", original_application_record_content)
      File.write("app/models/post.rb", original_post_content)
      File.write("app/models/comment.rb", original_comment_content)
      File.write("app/models/user.rb", original_user_content)
      File.write("config/who_am_i.yml", config_yml)

      rake_run do |rake|
        WhoAmI.load_rake_tasks
        Rake::Task[:who_am_i].invoke
      end

      assert_equal(
        original_application_record_content,
        File.read("app/models/application_record.rb")
      )
      assert_equal(
        "# == Schema Info\n" \
        "#\n" \
        "# Table name: posts\n" \
        "#\n" \
        "#   id            integer     not null, primary key\n" \
        "#   user_id       integer\n" \
        "#   content       text\n" \
        "#   created_at    datetime    not null\n" \
        "#   updated_at    datetime    not null\n" \
        "#\n" \
        "\n" \
        "class Post < ApplicationRecord\n" \
        "  has_many :comments\n" \
        "end\n",
        File.read("app/models/post.rb")
      )

      assert_equal(
        "# == Schema Info\n" \
        "#\n" \
        "# Table name: comments\n" \
        "#\n" \
        "#   id            integer     not null, primary key\n" \
        "#   post_id       integer\n" \
        "#   user_id       integer\n" \
        "#   name          string      not null\n" \
        "#   content       text\n" \
        "#   created_at    datetime    not null\n" \
        "#   updated_at    datetime    not null\n" \
        "#\n" \
        "\n" \
        "# This is my favorite class!\n" \
        "\n" \
        "class Comment < ActiveRecord::Base\n" \
        "  belongs_to :post\n" \
        "end\n",
        File.read("app/models/comment.rb")
      )

      assert_equal(
        "# == Schema Info\n" \
        "#\n" \
        "# Table name: users\n" \
        "#\n" \
        "#   id            integer     not null, primary key\n" \
        "#   name          string      not null\n" \
        "#   created_at    datetime    not null\n" \
        "#   updated_at    datetime    not null\n" \
        "#\n" \
        "\n" \
        "class User < ActiveRecord::Base\n" \
        "  has_many :posts\n" \
        "end\n",
        File.read("app/models/user.rb")
      )
    end
  end
end
