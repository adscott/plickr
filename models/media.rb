require 'flickraw-cached'
require './models/cache'
require './models/conf'

class Media
  attr_accessor :id, :thumbnail, :url

  def initialize(opts)
    @id = opts[:id]
    @thumbnail = opts[:thumbnail]
    @url = opts[:url]
  end

  def self.recent
    fetch_flickr_ids.map { |id| Media.from_flickr_id(id) }.sort { |a,b| b.id <=> a.id }
  end

  private

  def self.flickr_delegate
    @@flickr_delegate ||= Media.init_flickr_delegate
  end

  def self.init_flickr_delegate
    FlickRaw.api_key = Conf.value('FLICKR_API_KEY')
    FlickRaw.shared_secret = Conf.value('FLICKR_SHARED_SECRET')
    flickr.access_token = Conf.value('FLICKR_ACCESS_TOKEN')
    flickr.access_secret = Conf.value('FLICKR_ACCESS_SECRET')
    flickr
  end

  def self.from_id(id)
    from_flickr_id(id) if fetch_flickr_ids.include?(id)
  end

  def self.from_flickr(media, id)
    raw_opts = {
      id: id,
      thumbnail: media.detect { |img| img['label'] == 'Large Square' }['source'],
      url: media.reduce { |memo, img| img['width'].to_i > memo['width'].to_i ? img : memo }['source'],
    }
    opts = raw_opts.reduce({}) do |memo,(k,v)|
      memo[k] = v.is_a?(String) ? CGI::escapeHTML(v) : v
      memo
    end
    Media.new(opts)
  end

  def self.from_flickr_id(id)
    Cache.instance.fetch("media-#{id}") do
      from_flickr(Media.flickr_delegate.photos.getSizes(photo_id: id), id)
    end
  end

  def self.fetch_flickr_ids
    Cache.instance.fetch('recent', 300) do
      all_pages
    end
  end

  def self.all_pages(page=1)
    photos = Media.flickr_delegate.people.getPhotos(user_id: Conf.value('FLICKR_ACCOUNT'), per_page: 500, page: page).map { |photo| photo.id }
    photos.size < 500 ? photos : photos.concat(all_pages(page + 1))
  end
end
