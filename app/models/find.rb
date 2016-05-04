class Find < ActiveRecord::Base
    #APIの問い合わせ先とりあえずは固定で仮置き
    @@api_key = 'be37f05056113d51'

    def getShopInfos(name = '', location = '')
      finds = parseXml (location)

      if !name.blank? && !finds[0].image_url.blank? then
        if location.blank? then
            #位置情報未取得
            Search.create(name:name,image_url:finds[0].image_url)
          else
            #位置情報取得済み
            Search.create(name:name,image_url:finds[0].image_url,location:location)
          end
      end
      return finds
    end

    private
    def parseXml (location)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      require 'uri'

      if !location.blank? then
        keyword = '東京都渋谷区道玄坂'
      else
        keyword = '東京都渋谷区道玄坂'
      end
      count = '28'
      #url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=' + @@api_key +'&large_area=' + large_area + '&middle_area=' + middle_area + '&count=' + count + '&start=' + start
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=' + @@api_key +'&keyword=' + keyword + '&count=' + count

      xml  = open(URI.escape(url)).read.toutf8

      hash = Hash.from_xml(xml)
      finds = []
      if !hash['results']['shop'].nil? then
        hash['results']['shop'].each do |shop|
          find = Find.new
          # debug code
          #p shop
          # puts "id:" + shop['id']
          # puts "name:" + shop['name']
          # puts "url:" + shop['urls']['pc']
          # puts "pic:" + shop['photo']['pc']['l']
          
          find.shop_id = shop['id']
          find.name = shop['name']
          find.url = shop['urls']['pc']
          find.image_url = shop['photo']['pc']['l']
          finds << find
        end
      end
      finds.shuffle
      return finds
    end

    private
    def getLocationDetails
      count = '15'
      String start = [*1..1000].sample.to_s
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=' + @@api_key +'&large_area=' + large_area + '&middle_area=' + middle_area + '&count=' + count + '&start=' + start

      xml  = open( url ).read.toutf8

      hash = Hash.from_xml(xml)
      finds = []
      hash['results']['shop'].each do |shop|
        find = Find.new
        find.shop_id = shop['id']
        find.name = shop['name']
        find.url = shop['urls']['pc']
        find.image_url = shop['photo']['pc']['l']
        finds << find
      end
      finds.shuffle
      return find
    end
end
