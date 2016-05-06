class Find < ActiveRecord::Base
    #APIの問い合わせ先とりあえずは固定で仮置き
    @@recruit_api_key = 'key=be37f05056113d51'
    @@gnavi_api_key = 'keyid=51869db089685e458c0de567e10bf5cc'

    def getShopInfos(name = '', location = '',full_location = '')
      location = locationStrChk (location)
      finds = parseXml (location)
      if #!name.blank? && \
         !full_location.blank? \
         && !finds[0].image_url.nil? then
        exist_chk = Search.where(name:name,location:location,full_location:full_location).first_or_initialize
        if !exist_chk.blank? then
          Search.create(name:name,image_url:finds[0].image_url,location:location,full_location:full_location)
        end
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
    def parseXml (location)
      finds = []
      begin
        finds = getHotpepperAPIdata(location)
        finds.push(getGnaviAPIdata(location))
        finds.flatten!
        finds.shuffle!
      rescue Exception => e
         finds = []
         p e.message
         p "API searched exception catch!"
       end
      return finds
    end

    def getHotpepperAPIdata(location)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      require 'uri'
      keyword = '&keyword=' + location
      count = '&count=20'
      order = '&order=' + [*1].sample.to_s
      url  = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?' + @@recruit_api_key + keyword +  count + order

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
          finds.push(find)
        end
      end
      return finds
    end

    private
    def getGnaviAPIdata(location)
      require 'open-uri'
      require 'kconv'
      require 'active_support/core_ext/hash/conversions'
      require 'uri'
      address = '&address=' + location
      hit_per_page = '&hit_per_page=20'
      url  = 'http://api.gnavi.co.jp/RestSearchAPI/20150630/?' + @@gnavi_api_key + address + hit_per_page
      xml  = open(URI.escape(url)).read.toutf8
      hash = Hash.from_xml(xml)
      finds = []
      if !hash['response']['rest'].nil? then
        hash['response']['rest'].each do |rest|
          find = Find.new
          find.shop_id = rest['id']
          find.name = rest['name']
          find.url = rest['url']
          find.image_url = 'No image'
          if !rest['image_url']['shop_image1'].blank? then
            find.image_url = rest['image_url']['shop_image1']
          elsif !rest['image_url']['shop_image2'].blank?
            find.image_url = rest['image_url']['shop_image2']
          end
          finds.push(find)
        end
      end
      return finds
    end

    def
    locationStrChk (location)
      if location.blank? then
        location = '東京都渋谷区道玄坂'
      end
      return location
    end

end
