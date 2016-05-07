class SearchesController < ApplicationController
    @title = 'phogs'
    def index
      @searches = Search.all.page(params[:page]).per(5).order("created_at DESC")
      @title = 'phogs'
    end

    def map
      @searches = Search.all
      @hash = Gmaps4rails.build_markers(@searches) do |search, marker|
               marker.lat search.latitude
               marker.lng search.longitude
               marker.infowindow search.full_location
               marker.json({title: search.location})
      end
      @title = 'phogs'
    end
    def get_location
      require 'geocoder'
      @formatted_address = ''
      @keywords_address    = ''
      @get_status = '現在位置取得'
      @lat = params[:lat]
      @lon = params[:lon]
      if !@lat.nil? && !@lon.nil? then
        begin
          Geocoder.configure(:language  => :ja)
          formatted_point = @lat.to_s + ',' + @lon.to_s
          searched_data = Geocoder.search(formatted_point)
          #searched_data = Geocoder.search("35.4619297,139.5490377")
          parseSearchedData(searched_data)
          @get_status = '現在位置取得完了'
        rescue Exception => e
          @get_status = '現在位置取得失敗'
          @get_status = @formatted_address
          p e.message
          p "geo searched exception catch!"
        end
     end
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
      #redirect_to anction: finds :index
    end

    private
    def search_params
      params.permit(:name)
    end

    def parseSearchedData (searched_data)
      keywords_arr = []
      if !searched_data[0].data.nil? then
          @formatted_address = searched_data[0].data["formatted_address"]
          searched_data[0].data['address_components'].each do |address_component|
            types = address_component['types']
            if    types.include?('administrative_area_level_1')\
               || types.include?('ward')\
               || types.include?('locality')\
               || types.include?('sublocality_level_1')
               then
              keywords_arr << address_component['long_name']
            end
         end
         keywords_arr.reverse!
         @keywords_address = keywords_arr.join('')
      end
    end

end
