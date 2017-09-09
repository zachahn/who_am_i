require "test_helper"

class DirectoryTest < TestCase
  include Migrate

  def setup
    migrate!
  end

  def test_files
    directory = new_directory
    files = directory.files

    assert_includes(files, models_abspath + "/post.rb")
    assert_includes(files, models_abspath + "/category.rb")
  end

  def test_tables
    directory = new_directory
    tables = directory.tables

    assert_includes(tables, "post")
    assert_includes(tables, "categories")
  end

  def test_classlikes
    directory = new_directory
    classlikes = directory.classlikes

    post = classlikes.find { |cl| cl.name == :Post }
    category = classlikes.find { |cl| cl.name == :Category }

    assert_equal(models_abspath + "/post.rb", post.filename)
    assert_equal(models_abspath + "/category.rb", category.filename)
  end

  def test_models
    directory = new_directory
    models = directory.models

    assert_equal(true, models.map(&:activerecord?).all?)
    assert_includes(models.map(&:full_name), "::Post")
    assert_includes(models.map(&:full_name), "::Category")
  end

  private

  def new_directory
    WhoAmI::Directory.new(
      search: ["test/support/models"],
      connection: ActiveRecord::Base.connection
    )
  end

  def models_abspath
    File.expand_path("test/support/models")
  end
end
