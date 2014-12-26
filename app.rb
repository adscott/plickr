require 'sinatra'
require './models/user'
require './models/media'

def far_future
  Time.now + 60*60*24*356*3
end

set :haml, format: :html5, layout: :layout

get '/' do
  haml :index, locals: {title: 'Hi'}
end

get '/:digest/' do
  pass unless User.allowed(params[:digest])
  haml :photos, locals: {title: 'Photos', media: Media.recent}
end

get '/:digest/photo/:id' do
  pass unless User.allowed(params[:digest])
  media_with_index = Hash[Media.recent.map.with_index.to_a]
  photo = media_with_index.keys.find { |m| m.id == params[:id] }
  photo_position = media_with_index[photo]
  previous_photo = (photo_position - 1) >= 0 ? media_with_index.keys[photo_position - 1] : nil
  next_photo = (photo_position + 1) < media_with_index.keys.length ? media_with_index.keys[photo_position + 1] : nil
  haml :photo, locals: {title: 'Photo', photo: photo, previous_photo: url_for(previous_photo, params[:digest]), next_photo: url_for(next_photo, params[:digest])}
end

get '/stylesheets/:stylesheet.css' do |stylesheet|
  expires far_future, :public, :must_revalidate
  scss :"stylesheets/#{stylesheet}"
end

def url_for(photo, digest)
  photo.nil? ? nil : "/#{digest}/photo/#{photo.id}"
end

helpers do
  def versioned_scss(stylesheet)
    "/stylesheets/#{stylesheet}.css?#{File.mtime(File.join('views', 'stylesheets', "#{stylesheet}.scss")).to_i.to_s}"
  end

  def versioned_asset(asset)
    "#{asset}?#{File.mtime(File.join('public', asset)).to_i.to_s}"
  end
end
