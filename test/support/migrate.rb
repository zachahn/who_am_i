module Migrate
  def migrate!
    setup_activerecord_sqlite!
    migration_schema
  end

  def setup_activerecord_sqlite!
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:"
    )
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = false

    if Object.const_defined?("Foreigner")
      if !$foreigner_loaded
        Foreigner.load
        $foreigner_loaded = true
      end
    end
  end
end
