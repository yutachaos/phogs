class FindsController < ApplicationController

  def index
     @finds = Find.new
     @finds = @finds.parseXml
     #binding.pry
  end

end
