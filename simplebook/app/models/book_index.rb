class BookIndex < ActiveRecord::Base
  has_many :books
  #english_name, genre_id, jname
  GENRE_DATA = %w(
light_novels 1 ranobe
novels 2 novel
comic 3 manga
)
  Genre = Struct.new :id, :ename, :jname
  GENRES = GENRE_DATA.in_groups_of(3).map{ |v| Genre.new(v[0], v[1], v[2])}
end
