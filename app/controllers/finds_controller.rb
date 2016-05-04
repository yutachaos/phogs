class FindsController < ApplicationController

  def index
     @finds = Find.new
     @finds = @finds.getShopInfos()
     #binding.pry
  end

  def result
     @finds = Find.new
     puts find_params
     @finds = @finds.getShopInfos(find_params)
  end

  private
  def find_params
    params.permit(:name)
  end
end
