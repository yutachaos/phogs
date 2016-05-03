class Find < ActiveRecord::Base

    def parseXml
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      #APIの問い合わせ先とりあえずparseが実装できるまでは固定で仮置き
      api_key = 'be37f05056113d51'
      large_area = 'Z011'
      middle_area = 'Y030'
      count = '1'
      String start = [*1..1000].sample.to_s
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=' +api_key +'&large_area=' + large_area + '&middle_area=' + middle_area + '&count=30' + count + '&start=' + start

      xml  = open( url ).read.toutf8

      hash = Hash.from_xml(xml)
      finds = []
      hash['results']['shop'].each do |shop|
        find = Find.new
        #p shop
        # debug

        # puts "id:" + shop['id']
        # puts "name:" + shop['name']
        # puts "url:" + shop['urls']['pc']
        # puts "pic:" + shop['photo']['pc']['l']
        # add
        find.shop_id = shop['id']
        find.name = shop['name']
        find.url = shop['urls']['pc']
        find.image_url = shop['photo']['pc']['l']
        # 配列
        finds << find
      end
      return finds
    end

end
