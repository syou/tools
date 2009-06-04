class Author < ActiveRecord::Base
  attr_accessor :author_name
  attr_accessor :authorship_name

  has_many :author_books, :foreign_key => "author_id", :class_name => "Book"
  has_many :authorship_books, :forieign_key => "authorship_id", :class_name => "Book"

  def before_create
    if new_record?
    end

  end


end
