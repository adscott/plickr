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
  haml :photo, locals: {title: 'Photo', media: Media.recent.find { |m| m.id == params[:id] }}
end

get '/stylesheets/:stylesheet.css' do |stylesheet|
  expires far_future, :public, :must_revalidate
  scss :"stylesheets/#{stylesheet}"
end

helpers do
  def versioned_scss(stylesheet)
    "/stylesheets/#{stylesheet}.css?#{File.mtime(File.join('views', 'stylesheets', "#{stylesheet}.scss")).to_i.to_s}"
  end

  def versioned_asset(asset)
    "#{asset}?#{File.mtime(File.join('public', asset)).to_i.to_s}"
  end
end
