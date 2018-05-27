require "active_support/hash_with_indifferent_access"

module Migrate
  def migrate_sqlite
    sqlite_db_config = ActiveSupport::HashWithIndifferentAccess.new(
      adapter: "sqlite3",
      database: ":memory:"
    )

    migration_setup(sqlite_db_config)

    ActiveRecord::Base.establish_connection(sqlite_db_config)

    load_foreigner

    migration_schema

    yield
  ensure
    ActiveRecord::Base.remove_connection
  end

  def define_migration
    define_singleton_method(:migration_schema) do
      yield
    end
  end

  private

  def migration_setup(db_config)
    ActiveRecord::Base.configurations = { "test" => db_config }

    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = false
  end

  def load_foreigner
    if Object.const_defined?("Foreigner")
      Foreigner.load
    end
  end

  def drop_with_cascade
    if !requires_patching_of_drop?
      return
    end

    patch_drop

    yield
  ensure
    if requires_patching_of_drop?
      unpatch_drop
    end
  end

  def requires_patching_of_drop?
    Gem::Version.new(ActiveRecord::VERSION::STRING) <= Gem::Version.new("4.1.0")
  end

  def patch_drop
    metaclass =
      class << ActiveRecord::ConnectionAdapters::SchemaStatements; self; end

    metaclass.send(:alias_method, :original_drop_table, :drop_table)

    metaclass.send(:define_method, :drop_table) do |table_name, _ = {}|
      my_quoted_table_name = metaclass.send(:quote_table_name, table_name)

      metaclass.send(:execute, "DROP TABLE #{my_quoted_table_name} CASCADE")
    end
  end

  def unpatch_drop
    metaclass =
      class << ActiveRecord::ConnectionAdapters::SchemaStatements; self; end

    metaclass.send(:undef_method, :drop_table)
    metaclass.send(:alias_method, :drop_table, :original_drop_table)
    metaclass.send(:undef_method, :original_drop_table)
  end
end
