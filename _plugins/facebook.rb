module Jekyll
  class FacebookAlbum < Page
    def initialize(site, base, dir, item)
      @site = site
      @base = base
      @dir = dir
      @name = item['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + '.html' || 'index.html'

      self.process(@name)
      
      self.read_yaml(File.join(base, '_layouts'), 'gallery.html')
      
      self.data['title'] = item['title']
      self.data['items'] = item['items']
      self.data['category'] = item['id']
    end
  end
  
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
      
      username = Jekyll.configuration({})['profiles']['facebook'].split("/").last

      entries = getdata(username + '/albums')
      
      facebook = []
      
      for item in entries
        unless item['count'].nil? || item['count'] == 0
          data = Hash.new
          data['id'] = item['id']
          data['title'] = item['name']
          data['count'] = item['count']
          data['image'] = getdata(item['cover_photo'])['source']
          data['link'] = item['id']
          
          gallery = getdata(item['id'] + '/photos')
          data['items'] = []
          for photo in gallery
            data['items'].push(getdata(photo['id'])['source'])
          end
          
          slug = data['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          site.pages << FacebookAlbum.new(site, site.source, 'gallery/' + slug, data)
          
          facebook.push(data)
        end
        
      end
      
      site.data['facebook_photos'] = facebook
    end
  end
end
