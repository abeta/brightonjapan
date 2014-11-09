module Jekyll

  class FacebookAlbum < Page
    def initialize(site, base, dir, name, category, data)
      @site = site
      @base = base
      @dir = dir
      @name = name + '.html'

      self.process(@name)
      
      self.read_yaml(File.join(base, '_layouts'), 'gallery.html')
      
      self.data['title'] = data['title']
      self.data['image'] = data['image']
      self.data['items'] = data['items']
      self.data['category'] = category || 'gallery'
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
      
      albums = getdata(username + '/albums')
      
      for album in albums
        unless album['count'].nil? || album['count'] == 0
          data = Hash.new
          data['id'] = album['id']
          data['title'] = album['name']
          data['count'] = album['count']
          data['image'] = getdata(album['cover_photo'])['source']
          data['link'] = album['id']
          
          data['items'] = []
          photos = getdata(album['id'] + '/photos')
          
          for photo in photos
            item = Hash.new
            item['id'] = photo['id']
            item['title'] = photo['name']
            item['image'] = getdata(photo['id'])['source']
            item['id'] = photo['id']
            data['items'].push(item)
            site.pages << FacebookAlbum.new(site, site.source, 'gallery/' + slug, 'index', data)
          end
          
          slug = data['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
          site.pages << FacebookAlbum.new(site, site.source, 'gallery/' + slug, 'index', data)
          
          facebook.push(data)
        end
      end
    end
    
  end
  
end
