require 'sinatra'
require './models/user'
require './models/media'

get '/' do
  'Hello World!'
end

get '/:digest/' do
  pass unless User.allowed(params[:digest])
  Media.recent.last.thumbnail
end
