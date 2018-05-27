require "test_helper"

class CommentTest < TestCase
  include Migrate

  def test_plain_table
    define_migration do
      ActiveRecord::Schema.define do
        create_table :thingamajigs, force: true do |t|
          t.string :name
        end
      end
    end

    expected =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: thingamajigs\n" \
      "#\n" \
      "#   id      integer    not null, primary key\n" \
      "#   name    string\n" \
      "#\n"

    migrate_sqlite do
      engine = WhoAmI::Comment.new(table_name: "thingamajigs")
      result = engine.output

      assert_equal(expected, result)
    end
  end

  def test_index
    define_migration do
      ActiveRecord::Schema.define do
        create_table :thingamajigs, force: true do |t|
          t.string :name
        end

        add_index :thingamajigs, :name
      end
    end

    expected =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: thingamajigs\n" \
      "#\n" \
      "#   id      integer    not null, primary key\n" \
      "#   name    string\n" \
      "#\n" \
      "# Indices:\n" \
      "#\n" \
      "#   index_thingamajigs_on_name    (name)\n" \
      "#\n"

    migrate_sqlite do
      engine = WhoAmI::Comment.new(table_name: "thingamajigs")
      result = engine.output

      assert_equal(expected, result)
    end
  end

  def test_foreign_key
    define_migration do
      ActiveRecord::Schema.define do
        create_table :authors, force: true do |t|
          t.string :name, null: false, default: "Mr F"
        end

        create_table :posts, force: true do |t|
          t.integer :author_id, null: false
          t.text :content
        end

        add_foreign_key :posts, :authors
      end
    end

    expected_authors =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: authors\n" \
      "#\n" \
      "#   id      integer    not null, primary key\n" \
      "#   name    string     not null, default (Mr F)\n" \
      "#\n"

    expected_posts =
      "# == Schema Info\n" \
      "#\n" \
      "# Table name: posts\n" \
      "#\n" \
      "#   id           integer    not null, primary key\n" \
      "#   author_id    integer    not null\n" \
      "#   content      text\n" \
      "#\n"

    migrate_sqlite do
      engine = WhoAmI::Comment.new(table_name: "authors")
      result_authors = engine.output

      assert_equal(expected_authors, result_authors)

      engine = WhoAmI::Comment.new(table_name: "posts")
      result_posts = engine.output

      assert_equal(expected_posts, result_posts)
    end
  end
end
