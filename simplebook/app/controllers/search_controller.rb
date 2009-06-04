class SearchController < ApplicationController
  def index
    if request.post?
      @amazon_ec2= AmazonEc2.new(params)
    end
  end
end
