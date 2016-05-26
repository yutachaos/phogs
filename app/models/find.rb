class Find < ActiveRecord::Base

    #APIの問い合わせ先とりあえずは固定で仮置き
    RECRUIT_API_KEY = 'key=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa️'
    RECRUIT_OFFER_TEXT = '画像提供：ホットペッパー グルメ'
    GNAVI_API_KEY = 'keyid=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    GNAVI_OFFER_TEXT = '提供：ぐるなび'

    def getShopInfos(name = '', location = '',full_location = '',lat = '',lon = '')
      location = locationStrChk (location)
      finds = parseXml(location,lat,lon)

      if #!name.blank? && \
         !full_location.blank? \
         && !finds.blank? then
        exist_chk = Search.where(name:name,location:location,full_location:full_location).first_or_initialize
        if !exist_chk.blank? then
          Search.create(name:name,image_url:finds[0].image_url,service_remark:finds[0].service_remark,location:location,full_location:full_location,latitude:lat,longitude:lon)
        end
      end
      return finds
    end

    def getUserShopInfos(id)
      search = Search.find(id)
      location = locationStrChk (search.location)
      finds = parseXml(location,search.latitude,search.longitude)
      return finds
    end

    private
    def parseXml (location,lat,lon)
      finds = []
      begin
        if location.empty? then
          raise "location include 'Unnamed Road'! "
        end
        finds = getHotpepperAPIdata(location,lat,lon)
        finds.push(getGnaviAPIdata(location,lat,lon))
        finds.flatten!
        finds.shuffle!
      rescue Exception => e
          finds = []
          p e.message
          p "API searched exception catch!"
      end
      return finds
    end

    def getHotpepperAPIdata(location,lat,lon)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      require 'uri'
      keyword = '&keyword=' + location
      count = '&count=20'
      order = '&order=' + [*1].sample.to_s
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?' + RECRUIT_API_KEY + keyword +  count + order

      xml  = open(URI.escape(url)).read.toutf8
      hash = Hash.from_xml(xml)
      finds = []
      if !hash['results']['shop'].nil? then
        hash['results']['shop'].each do |shop|
          find = Find.new
          find.shop_id = shop['id']
          find.name = shop['name']
          find.url = shop['urls']['pc']
          find.distance = get_distance(lat, lon, shop['lat'], shop['lng'])
          if !shop['photo']['pc']['l'].blank? then
            find.image_url = shop['photo']['pc']['l']
            find.service_remark = RECRUIT_OFFER_TEXT
          else
            next
          end

          finds.push(find)
        end
      end
      return finds
    end

    private
    def getGnaviAPIdata(location,lat,lon)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      require 'uri'
      address = '&address=' + location
      hit_per_page = '&hit_per_page=50'
      url  = 'http://api.gnavi.co.jp/RestSearchAPI/20150630/?' + GNAVI_API_KEY + address + hit_per_page
      xml  = open(URI.escape(url)).read.toutf8
      hash = Hash.from_xml(xml)
      finds = []
      if !hash['response']['rest'].nil? then
        hash['response']['rest'].each do |rest|
          find = Find.new
          find.shop_id = rest['id']
          find.name = rest['name']
          find.url = rest['url']
          find.distance = get_distance(lat, lon, rest['latitude'], rest['longitude'])
          if !rest['image_url']['shop_image1'].blank? then
            find.image_url = rest['image_url']['shop_image1']
          elsif !rest['image_url']['shop_image2'].blank?
            find.image_url = rest['image_url']['shop_image2']
          else
            next
          end
          find.service_remark = GNAVI_OFFER_TEXT
          finds.push(find)
        end
      end
      return finds
    end

    def
    locationStrChk (location)
      if location.blank? then
        location = '東京都渋谷区道玄坂'
      elsif location.include?('Unnamed Road') then
        location = ''
      end
      return location
    end

    def get_distance(lat1, lng1, lat2, lng2)
      y1 = lat1.to_f * Math::PI / 180
      x1 = lng1.to_f * Math::PI / 180
      y2 = lat2.to_f * Math::PI / 180
      x2 = lng2.to_f * Math::PI / 180
      earth_r = 6378140
      deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
      distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2)
      distance = distance.round
      return distance
    end

end
