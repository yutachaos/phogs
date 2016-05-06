class FindsController < ApplicationController
  @title = 'Phogs'
  def index
     @finds = Find.new
     @finds = @finds.getShopInfos()
     #binding.pry
  end

  def result
     @finds = Find.new
     @finds = @finds.getShopInfos(find_params['name'],find_params['location'],find_params['full_location'],find_params['lat'],find_params['lon'])
     @title = 'result'
  end

  def show
     @finds = Find.new
     @finds = @finds.getUserShopInfos(find_params['id'])
     @title = 'show result'
  end


  private
  def find_params
    params.permit(:id,:name,:location,:full_location,:lat,:lon)
  end
end
