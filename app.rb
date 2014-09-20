require 'sinatra'
require './user'

get '/' do
  'Hello World!'
end

get '/:digest/' do
  pass unless User.allowed(params[:digest])
  'Photos!'
end
