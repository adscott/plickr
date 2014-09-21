require 'sinatra'
require 'haml'
require './models/user'
require './models/media'

set :haml, format: :html5, layout: :layout

get '/' do
  'Hello World!'
end

get '/:digest/' do
  pass unless User.allowed(params[:digest])
  haml :photos, locals: {title: 'photos', media: Media.recent}
end
