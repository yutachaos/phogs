class FindsController < ApplicationController

  def index
     @finds = Find.new
     @finds = @finds.getShopInfos()
     #binding.pry
  end

  def result
     @finds = Find.new
     @finds = @finds.getShopInfos(find_params['name'],find_params['location'])
  end

  private
  def find_params
    params.permit(:name,:location)
  end
end
