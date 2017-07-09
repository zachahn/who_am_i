class Post < ApplicationRecord
  self.table_name = :posts

  belongs_to :category
end
