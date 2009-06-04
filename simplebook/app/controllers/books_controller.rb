class BooksController < ApplicationController
  layout "book"

  def new
    @book = Book.new
    params[:books] ||= { }
    @book.volumes.build while @book.volumes.size < Volume::DEFAULT_COUNT     
  end

  def insert_volume
    render :text => "" and return if params[:count].blank?
    render :inline => <<-INSERT
    <tr>
      <td><%= text_field_tag :"volumes[#{params[:count]}][subtitle]", "", :class => "example2" %></td>
      <td><%= text_field_tag :"volumes[#{params[:count]}][author_name]", "", :class => "example2" %></td>
      <td><%= text_field_tag :"volumes[#{params[:count]}][no]", "" , :class => "example2" %></td>      
    </tr>
INSERT
  end


end
