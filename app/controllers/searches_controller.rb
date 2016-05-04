class SearchesController < ApplicationController

    def index
       @search = Search.new
       @searches = Search.all
       #binding.pry
    end

    def get_location
      respond_to do |format|
        format.js
    end

    def create
        #name = search_params
        #image_url =
        #Search.create()
        #redirect_to anction: finds :index
    end

    def destroy
      search = Search.find(params[:id])
      Search.destroy
    end

    def edit
      @search = Search.find(params[:id])
    end

    def update
      search = Search.find(params[:id])
    end

    def show
      @search = Search.find(params[:id])
      #redirect_to anction: finds :index
    end

    private
    def search_params
      params.permit(:name)
    end

  end
end
