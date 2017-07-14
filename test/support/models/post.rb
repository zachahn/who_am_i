class Post < ApplicationRecord
  self.table_name = :post

  belongs_to :category
end
