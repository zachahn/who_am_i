module Migrate
  def migrate!
    setup_activerecord_sqlite!
    migration_schema
  end

  def migration_schema
    ActiveRecord::Schema.define do
      create_table :post, force: true do |t|
        t.integer :category_id
        t.string :author, null: false, default: "Mr F"
        t.text :content
        t.timestamps null: false
      end

      create_table :categories, force: true do |t|
        t.string :name
        t.timestamps null: false
      end
    end
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
