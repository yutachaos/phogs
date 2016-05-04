class Find < ActiveRecord::Base

    def getShopInfos(name = nil, location = nil)
      finds = parseXml (location)
      if !name.nil?
        #FIX name is not empty then saved userdata
        search = Search.new
      end
      return finds
    end

    def parseXml (location)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      #APIの問い合わせ先とりあえずは固定で仮置き
      api_key = 'be37f05056113d51'

      if location.nil? then
        large_area = 'Z011'
        middle_area = 'Y030'
      else
        #FIX ME
        large_area = 'Z011'
        middle_area = 'Y030'
      end
      count = '37'
      String start = [*1..1000].sample.to_s
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=' +api_key +'&large_area=' + large_area + '&middle_area=' + middle_area + '&count=' + count + '&start=' + start

      xml  = open( url ).read.toutf8

      hash = Hash.from_xml(xml)
      finds = []
      hash['results']['shop'].each do |shop|
        find = Find.new
        # debug　code
        #p shop
        # puts "id:" + shop['id']
        # puts "name:" + shop['name']
        # puts "url:" + shop['urls']['pc']
        # puts "pic:" + shop['photo']['pc']['l']
        # add
        find.shop_id = shop['id']
        find.name = shop['name']
        find.url = shop['urls']['pc']
        find.image_url = shop['photo']['pc']['l']
        finds << find
      end
      return finds

    end
end
