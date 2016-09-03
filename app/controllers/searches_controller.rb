class SearchesController < ApplicationController
    @title = 'teens'
    def index
      @searches = Search.all.page(params[:page]).per(3).order("created_at DESC")
    end

    def create
    end

    def destroy
      search = Search.delete(params[:id])
      Search.destroy
    end

    def edit
      @search = Search.save(params[:id])
    end

    def update
      search = Search.save(params[:id])
    end

    def show
      @search = Search.find(params[:id])
    end

    private
    def search_params
      params.permit(:name)
    end

end
