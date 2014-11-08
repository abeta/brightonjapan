module Jekyll
  class FacebookPhotosGenerator < Generator
    def getdata(path)
      url = "http://graph.facebook.com/#{path}"
      json_data = Net::HTTP.get_response(URI.parse(url)).body
      data = JSON.parse(json_data)
      return data['data'] || data
    end
    
    def generate(site)
      require 'net/http'
      require 'rubygems'
      require 'json'

      entries = getdata(Jekyll.configuration({})['facebook'] + '/albums')
      
      facebook = []
      
      for item in entries
        unless item['count'].nil? || item['count'] == 0
          data = Hash.new
          data['id'] = item['id']
          data['title'] = item['name']
          data['count'] = item['count']
          data['image'] = getdata(item['cover_photo'])['source']
          data['link'] = item['id']
        
          facebook.push(data)
        end
        
      end
      
      site.data['facebook_photos'] = facebook
    end
  end
end
