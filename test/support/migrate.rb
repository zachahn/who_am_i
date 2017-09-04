module Migrate
  def migrate!
    support_setup_ar!
    support_migrate!
  end

  def support_migrate!
    ActiveRecord::Schema.define do
      create_table :post, force: true do |t|
        t.integer :category_id
        t.string :author
        t.text :content
        t.timestamps
      end

      create_table :categories, force: true do |t|
        t.string :name
        t.timestamps
      end
    end
  end

  def support_setup_ar!
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:"
    )
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = false
  end
end
