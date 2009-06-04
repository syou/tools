class Book < ActiveRecord::Base
  belongs_to :book_index
  has_many :volumes
  belongs_to :author
  belongs_to :authorship, :class_name => "Author"
  belongs_to :publisher
end
