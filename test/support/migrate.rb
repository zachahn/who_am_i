module Migrate
  def migrate!
    setup_ar!
    support_migrate!
  end

  def support_migrate!
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

  def setup_ar!
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:"
    )
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = false
  end
end
