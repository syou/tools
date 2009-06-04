# -*- coding: utf-8 -*-
#connet amazno ec2 and get datas.
class AmazonEc2
  require 'rubygems'
  require 'amazon/ecs'
 
  ACCESS_KEY = "04KWCPFABBS5S27AKFG2"
  SECRET_ACCESS_KEY = "jKZoi8IQEuPkqrAer6b3skJswgz5EXTCgTaQhjTq"

  Amazon::Ecs.debug = true
  Amazon::Ecs.options = {
    :aWS_access_key_id => ACCESS_KEY,
    :associate_tag => nil,
    :country => :jp
  }
 
  SEARCH_TYPE_DATA = %w(
ISBN 1
Keyoord 2
)

  #とってくる情報の量。いろいろあるが基本的にMedium, Small, Large
  INFO_TYPE = %w(Medium Small Large)

  #ソート順。 &Sort=
  #売れてる順番、価格安い、価格高い、発売日、タイトル(a-)、タイトル(z-a)
  SORT_VALUES = { :salesrank  => "売れている順番", :pricerank => "価格が安い順",  :"inverse-pricerank" => "価格が高い順", :daterank => "発売日順" , :titlerank => "本の名前昇順", :"-titlerank" =>  "本の名前降順"}
  SORT_KEYS = SORT_VALUES.map{|k,v| k }
  SORT_TYPES = SORT_VALUES.map{ |k,v| [v, k] }

  SearchType = Struct.new(:name, :type_id)
  SEARCH_TYPES = %w(keyword isbn)
  attr_reader :isbn
  def initialize(params)
    #isbn
    unless params[:isbn].blank?
      @search_type = :isbn
      @isbn = params[:isbn]
    end
    #keyword
    unless params[:keyword].blank?
      @search_type = :keyword
      @keyword = params[:keyword]
    end
    #sort
    @sort = params[:sort] if SORT_KEYS.include?(params[:sort])
  end


  def search_items
    SEARCH_TYPES.each do |search_type| 
      if search_type  == @search_type.to_s
        return self.send("search_by_#{@search_type}") 
      end
    end
  end

  private
  def search_by_isbn
    res = Amazon::Ecs.item_search(@isbn)
    res.items
  end
  #ref : www.goodpic.com/mt/archives2/2004/10/amazon_ecs_401.html
  def search_by_keyword
    res = Amazon::Ecs.item_search(@keyword, {
                                    :search_index => "Books", #探す種別。
                                    :response_group => "Medium", #とってくる情報の量
                                    :sort => @sort})
    res.items
  end

end

#Hack!
class Amazon::Element
  def title
    get('title')
  end
  def asin
    get('asin')
  end
  alias :isbn :asin
end
