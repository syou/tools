class Volume < ActiveRecord::Base
  attr_accessor :author_name
  DEFAULT_COUNT = 5
  belongs_to :author
  belongs_to :book

  def before_create
    #auto create and generate author
    if !self.author.blank?
      if @get_author = Author.find_by_name(self.author_name)
        self.author = @get_author
      else
       self.author = Author.create(:name => self.author_name)
      end
    end
  end

end
