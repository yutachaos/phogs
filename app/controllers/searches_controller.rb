class SearchesController < ApplicationController

    def index
       @search = Search.new
       @searches = Search.all
       #binding.pry
    end

    def get_location
      require 'geocoder'
      @address = ''
      lat = params[:lat]
      lon = params[:lon]

      if !lat.nil? && !lon.nil? then
        Geocoder.configure(:language  => :ja)
        formatted_point = lat.to_s + ',' + lon.to_s
        @address = Geocoder.address(formatted_point)
#        parseAddressData(@address)
       end
    end
    #TO DO
    # private
    # def parseAddressData (@address)
    #     if !@address.nil? then
    #       @address['address_components'].each do |address_component|
    #         if address_component['type'].include?() then

    #         end
    #       end
    #     end
    # end

    def create
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
