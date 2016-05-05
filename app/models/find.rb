class Find < ActiveRecord::Base
    #APIの問い合わせ先とりあえずは固定で仮置き
    @@api_key = 'be37f05056113d51'

    def getShopInfos(name = '', location = '',full_location = '')
      location = locationStrChk (location)
      finds = parseXml (location)
      if !name.blank? && !full_location.blank? && !finds[0].image_url.blank? then
        Search.create(name:name,image_url:finds[0].image_url,location:location,full_location:full_location)
      end
      return finds
    end

    def getUserShopInfos(id)
      search = Search.find(id)
      location = locationStrChk (search.location)
      finds = parseXml (location)
      return finds
    end

    private
    def
    locationStrChk (location)
      if location.blank? then
        location = '東京都,渋谷区,道玄坂'
      end
      return location
    end

    private
    def parseXml (location)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      require 'uri'

      keywords = createLocationStr(location)
      count = '28'
      order = [*1].sample.to_s
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=' + @@api_key + keywords + '&count=' + count + '&order=' + order

      xml  = open(URI.escape(url)).read.toutf8

      hash = Hash.from_xml(xml)
      finds = []
      if !hash['results']['shop'].nil? then
        hash['results']['shop'].each do |shop|
          find = Find.new
          find.shop_id = shop['id']
          find.name = shop['name']
          find.url = shop['urls']['pc']
          find.image_url = shop['photo']['pc']['l']
          finds << find
        end
      end
      finds.shuffle!
      return finds
    end

    private
    def createLocationStr(locationStr)
      keywords = ''
      locations = locationStr.split(",")
      locations.each do |location|
        keywords += '&keyword=' + location
      end
      return keywords
    end
end
